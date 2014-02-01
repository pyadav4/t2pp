package com.shc.mp.services;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Rpx {
	
	private static Logger log = LoggerFactory.getLogger(Rpx.class);
	
    private String apiKey;
    private String baseUrl;
    public Rpx(String apiKey, String baseUrl) {
        while (baseUrl.endsWith("/"))
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        this.apiKey = apiKey;
        this.baseUrl = baseUrl;
        
    }
    public String getApiKey() { return apiKey; }
    public String getBaseUrl() { return baseUrl; }
    public JSONObject authInfo(String token) {
        Map query = new HashMap();
        query.put("token", token);
        return apiCall("auth_info", query);
    }

    private JSONObject apiCall(String methodName, Map partialQuery) {
        Map query = null;
        JSONObject response = new JSONObject();
        if (partialQuery == null) {
            query = new HashMap();
        } else {
            query = new HashMap(partialQuery);
        }
        query.put("format", "json");
        query.put("apiKey", apiKey);
        StringBuffer sb = new StringBuffer();
        for (Iterator it = query.entrySet().iterator(); it.hasNext();) {
            if (sb.length() > 0) sb.append('&');
            try {
                Map.Entry e = (Map.Entry)it.next();
                sb.append(URLEncoder.encode(e.getKey().toString(), "UTF-8"));
                sb.append('=');
                sb.append(URLEncoder.encode(e.getValue().toString(), "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                throw new RuntimeException("Unexpected encoding error", e);
            }
        }
        String data = sb.toString();
        try {
        	URL url = new URL(baseUrl + "/api/v2/" + methodName);
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.connect();
            OutputStreamWriter osw = new OutputStreamWriter(
                conn.getOutputStream(), "UTF-8");
            osw.write(data);
            osw.close();
            InputStream is = conn.getInputStream();
            int ch =1;
            StringBuffer strContent = new StringBuffer("");
            while ((ch = is.read()) != -1)
            	strContent.append((char) ch);
            response = new JSONObject(strContent.toString());
            if (!response.get("stat").equals("ok")) {
                throw new RuntimeException("Unexpected API error");
            }
            return response;
        } catch (MalformedURLException e) {
        	log.info("error"+e.getMessage());
            throw new RuntimeException("Unexpected URL error", e);
        } catch (IOException e) {
        	log.info("error"+e.getMessage());
            throw new RuntimeException("Unexpected IO error", e);
        } catch (JSONException e) {
        	log.info("error"+e.getMessage());
            throw new RuntimeException("Unexpected XML error", e);
        } 
    }
    
    public static CommonUserDetailsBean processUserDetail(JSONObject responseObject) {
		CommonUserDetailsBean userDetailsObj = new CommonUserDetailsBean();
		try {
			log.info("entering process user details" );
			if(null != responseObject) {
				userDetailsObj.setStat(responseObject.getString("stat"));
				JSONObject profile = responseObject.getJSONObject("profile");
				log.info("profile: "+ profile.toString(1));
				if(profile.has("name")){
					JSONObject name = profile.getJSONObject("name");
					System.out.println("Name ****:: " + name.toString());
					if(profile.has("givenName")){
						userDetailsObj.setGivenName(name.getString("givenName"));
					}
					if(profile.has("familyName")){
						userDetailsObj.setFamilyName(name.getString("familyName"));
					}
					if(profile.has("formatted")){
						userDetailsObj.setName(name.getString("formatted"));
					}
				}
				
				if(profile.has("providerName")){
					userDetailsObj.setProviderName(profile.getString("providerName"));
				}
				
				if(profile.has("displayName")){
					userDetailsObj.setDisplayName(profile.getString("displayName"));
				}
				
				if(profile.has("email")){
					userDetailsObj.setEmail(profile.getString("email"));
				}
				
				if(profile.has("photo")){
					userDetailsObj.setPhoto(profile.getString("photo"));
				}
				if(profile.has("birthday")){
					userDetailsObj.setBirthday(profile.getString("birthday"));
				}
				if(profile.has("url")){
					userDetailsObj.setUrl(profile.getString("url"));
				}
				if(profile.has("identifier")){
					userDetailsObj.setIdentifier(profile.getString("identifier"));
				}
				if(profile.has("preferredUsername")){
					log.info("preferredUsername::"+profile.getString("preferredUsername"));
					userDetailsObj.setPreferredUsername(profile.getString("preferredUsername"));
				}
				if(profile.getString("providerName").equals("Facebook")) {
					if(profile.has("address")){
						JSONObject address = profile.getJSONObject("address");
						userDetailsObj.setAddress(address.getString("formatted"));
						userDetailsObj.setType(address.getString("type"));
					}
					if(profile.has("utcOffset")){
						userDetailsObj.setUtcOffset(profile.getString("utcOffset"));
					}
					if(profile.has("photo")){
						log.info("Photo from JSON :"+profile.getString("photo"));
						userDetailsObj.setPhoto(profile.getString("photo"));
					}
					if(profile.has("gender")){
						userDetailsObj.setGender(profile.getString("gender"));
					}
					
				}
				else if (profile.getString("providerName").equals("Google")) {
					if(profile.has("googleUserId")){
						userDetailsObj.setGender(profile.getString("googleUserId"));
					}
				}
			}
		} catch (Exception e) {
			log.error("Error in Process User Details :: "+e.getMessage());
		}
		log.info("coming out of process user details");
		return userDetailsObj;
	}
   
    
    
   
}