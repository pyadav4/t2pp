package com.shc.mp.services;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import java.net.URLEncoder;
import org.apache.commons.lang3.StringUtils;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.commons.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * This servlet makes an RPX Call using apiKey and janrainurl and gets the
 * response in an JSON Object format.
 * 
 */
@Component(immediate = true, description = "Janrain Servlet")
@Service(value = javax.servlet.Servlet.class)
@Properties(value = {
        @Property(name = "sling.servlet.extensions", value = { "html" }),
        @Property(name = "sling.servlet.methods", value = { "POST" }),
        @Property(name = "sling.servlet.paths", value = { "/libs/janrainservlet" }) })
public class JanRainAuthServlet extends SlingAllMethodsServlet {
    /**
     * Serial Version ID.
     */
    private static final long serialVersionUID = 1L;
    /**
     * Logger.
     */
    private Logger log = LoggerFactory.getLogger(JanRainAuthServlet.class);

    /**
     * Method used to get the RPX response. The input parameter must include a
     * valid apiKey and janrainurl. Writes the user information to the
     * SlingServletResponse.
     * 
     * {@inheritDoc}
     * 
     * @see org.apache.sling.api.servlets.SlingAllMethodsServlet#doPost(org.apache.sling.api.SlingHttpServletRequest,
     *      org.apache.sling.api.SlingHttpServletResponse)
     */
    protected final void doPost(final SlingHttpServletRequest request,
            final SlingHttpServletResponse response) throws ServletException,
            IOException {
        try {
            String apiKey ="fd153114075788a15b4ccbd9d29fc269f4c1cc9d";         // TODO need to read from property
            String janrainUrl = "https://social-login-platform.rpxnow.com";    // TODO need to read from property
            Rpx rpx = new Rpx(apiKey, janrainUrl);
            String redirectURL = request.getParameter("redirectURL");
            
            if (request.getParameter("token") == null) {
                log.info("Request token NULL");
            } else {
            	JSONObject resp = rpx.authInfo(request.getParameter("token"));
            	CommonUserDetailsBean userDetails = null;
            	
            	if (null != resp && resp.getString("stat").equals("ok")) {
					log.info("RPX Response:" + resp.toString(1));
					userDetails = Rpx.processUserDetail(resp);
					//System.out.println("RPX userdetails:" + userDetails.toString());
					log.info("RPX userdetails:" + userDetails.toString());
					if (null != userDetails) {
						request.getSession().setAttribute("userid",
								userDetails.getPreferredUsername());
						Map<String, String> cookieMap = new HashMap<String, String>();
						log.info("authorizable from janrain:"
								+ userDetails.getPreferredUsername());
						cookieMap.put(CommonConstants.displayName,
								userDetails.getDisplayName());
						if (StringUtils.isEmpty(userDetails.getFormattedName())) {
							cookieMap.put(CommonConstants.formattedName,
									userDetails.getName());
						} else {
							cookieMap.put(CommonConstants.formattedName,
									userDetails.getFormattedName());
						}
						cookieMap.put(CommonConstants.familyName,
								userDetails.getFamilyName());
						cookieMap.put(CommonConstants.provider,
								userDetails.getProviderName());
						cookieMap.put(CommonConstants.birthday,
								userDetails.getBirthday());
						cookieMap.put(CommonConstants.gender,
								userDetails.getGender());
						cookieMap.put(CommonConstants.photo, URLEncoder.encode(userDetails.getPhoto(), "UTF-8"));
						cookieMap.put(CommonConstants.authorizableId,
								URLEncoder.encode(userDetails.getDisplayName(),
										"UTF-8"));
						cookieMap.put(CommonConstants.identifier,
								userDetails.getIdentifier());
						prepareCookie(cookieMap, response);

					}
				}
            	log.info("Output ::: " + resp.toString());
            	System.out.println("Output ::: " + resp.toString());
            }

			if (StringUtils.isNotBlank(redirectURL)) {
                   // rd.forward(request,response);
                 response.sendRedirect(URLDecoder.decode(redirectURL, "UTF-8"));
				return;
			}

            return;
            
        } catch (Exception e) {
        	 log.info("Exception occured inside Jan Rain servlet");

        }
    }

    /**
     * {@inheritDoc}
     * 
     * @see org.apache.sling.api.servlets.SlingSafeMethodsServlet#doGet(org.apache.sling.api.SlingHttpServletRequest,
     *      org.apache.sling.api.SlingHttpServletResponse)
     */
    protected final void doGet(final SlingHttpServletRequest request,
            final SlingHttpServletResponse response) throws ServletException,
            IOException {
    	log.info("Request Inside get");
        doPost(request, response);
    }

    /**
     * This method prepares a cookie and add it to the response object
     * 
     * @param cookieMap
     * @param response
     */
    public final void prepareCookie(final Map<String, String> cookieMap,
            final HttpServletResponse response) {
        Cookie tempCookie = null;
        for (String key : cookieMap.keySet()) {
            tempCookie = new Cookie(key, cookieMap.get(key));
            log.info("cookie name::" + tempCookie.getName());
            System.out.println("Name:: " + tempCookie.getName() + " Value::" + cookieMap.get(key));
            tempCookie.setMaxAge(-1);
            tempCookie.setPath("/");
            response.addCookie(tempCookie);
        }
    }

}
