<%--
  ~
  ~ ADOBE CONFIDENTIAL
  ~ __________________
  ~
  ~  Copyright 2011 Adobe Systems Incorporated
  ~  All Rights Reserved.
  ~
  ~ NOTICE:  All information contained herein is, and remains
  ~ the property of Adobe Systems Incorporated and its suppliers,
  ~ if any.  The intellectual and technical concepts contained
  ~ herein are proprietary to Adobe Systems Incorporated and its
  ~ suppliers and are protected by trade secret or copyright law.
  ~ Dissemination of this information or reproduction of this material
  ~ is strictly forbidden unless prior written permission is obtained
  ~ from Adobe Systems Incorporated.
  --%><%@ page import="com.adobe.cq.social.commons.CollabUtil,
                       com.day.cq.commons.Externalizer,
                       com.day.cq.commons.JSONWriterUtil,
                       com.day.cq.commons.TidyJSONWriter,
                       com.day.cq.commons.date.DateUtil,
                       java.net.URLDecoder,
                       org.apache.commons.lang3.StringUtils,
                       javax.servlet.http.Cookie,
                       com.day.cq.wcm.api.WCMMode,
                       com.day.cq.xss.ProtectionContext,
                       com.day.cq.xss.XSSProtectionService,
                       org.apache.sling.api.SlingHttpServletRequest,
                       org.apache.sling.commons.json.io.JSONWriter,
                       java.io.StringWriter,
                       java.text.DateFormat,
                       java.util.Date, com.adobe.granite.security.user.UserPropertiesManager, com.adobe.granite.security.user.UserProperties, javax.jcr.PathNotFoundException"
        contentType="text/javascript" %><%!
%><%@ include file="/libs/foundation/global.jsp" %><%
%><%!

    void setProfileInitialData(JSONWriter writer, UserPropertiesManager upm,
                               SlingHttpServletRequest slingRequest,
                               String absoluteDefaultAvatar,
                               XSSProtectionService xss,Cookie[] cookies) throws Exception {
	
    
        writer.object();
        
        final Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
        final UserProperties userProperties = upm.getUserProperties(session.getUserID(), "profile");
        if (userProperties != null) {
        	
            String avatar = CollabUtil.getAvatar(userProperties, userProperties.getProperty(UserProperties.EMAIL),absoluteDefaultAvatar);
            //increase avatar size
            avatar = avatar == null ? "" : avatar.replaceAll("\\.32\\.",".80.");
            final String id = userProperties.getAuthorizableID();
            
           // writer.key("memberSince").value(memberSince);
            writer.key("avatar").value(avatar);
            writer.key("path").value(userProperties.getNode().getPath());

            Boolean isLoggedIn = id != null && !id.equals("anonymous");
            writer.key("isLoggedIn").value(isLoggedIn);
            writer.key("isLoggedIn" + JSONWriterUtil.KEY_SUFFIX_XSS)
                    .value(xss.protectForContext(ProtectionContext.PLAIN_HTML_CONTENT,isLoggedIn.toString()));

            writer.key("authorizableId")
                    .value(id);
            writer.key("authorizableId" + JSONWriterUtil.KEY_SUFFIX_XSS)
                    .value(xss.protectForContext(ProtectionContext.PLAIN_HTML_CONTENT,id));

            writer.key("formattedName")
                    .value(userProperties.getDisplayName());
           
            writer.key("formattedName" + JSONWriterUtil.KEY_SUFFIX_XSS)
                    .value(xss.protectForContext(ProtectionContext.PLAIN_HTML_CONTENT,userProperties.getDisplayName()));

            for (String key : userProperties.getPropertyNames()) {
                if (!key.startsWith("jcr:") &&
                    !key.startsWith("sling:") &&
                    !key.startsWith("cq:last") &&
                    !key.startsWith("memberSince") &&
                    !key.startsWith("birthday")) {

                    String s = userProperties.getProperty(key, null, String.class);
                    s = s != null ? s : "";
                    writer.key(key)
                            .value(s);
                    writer.key(key + JSONWriterUtil.KEY_SUFFIX_XSS)
                            .value(xss.protectForContext(ProtectionContext.PLAIN_HTML_CONTENT,s));
                }
            }

            Date created = userProperties.getProperty("memberSince", null, Date.class);
            if( created == null) {
                try {
                    created = userProperties.getNode().getProperty("jcr:created").getDate().getTime();
                } catch (PathNotFoundException e) {
                    // no created date set
                }
            }
            if( created != null ) {
                DateFormat df = DateUtil.getDateFormat("d MMM yyyy h:mm a", slingRequest.getLocale());
                
            }

            Date birthday = userProperties.getProperty("birthday", null, Date.class);
            if( birthday != null ) {
                DateFormat df = DateUtil.getDateFormat("d MMM yyyy", slingRequest.getLocale());
                writer.key("birthday")
                    .value(df.format(birthday));
            }
        }
        
        if(cookies != null) {
            for(Cookie cookie : cookies) {
                if(StringUtils.equalsIgnoreCase("displayName",cookie.getName())){
                     writer.key("displayName").value(cookie.getValue());
                 }
                if(StringUtils.equalsIgnoreCase("gender",cookie.getName())){
                     writer.key("gender").value(cookie.getValue());
                 }
                if(StringUtils.equalsIgnoreCase("photo",cookie.getName())){
                    writer.key("photo").value(cookie.getValue());
                 }
                else if(StringUtils.equalsIgnoreCase("avatar",cookie.getName())){
                	  writer.key("photo").value(cookie.getValue());
                }
                if(StringUtils.equalsIgnoreCase("userId",cookie.getName())){
                    writer.key("userId").value(cookie.getValue());
                 }
                if(StringUtils.equalsIgnoreCase("formattedName",cookie.getName())){
                    writer.key("fName").value(cookie.getValue());
                 }
                if(StringUtils.equalsIgnoreCase("authorizableId",cookie.getName())){
                    writer.key("aId").value(cookie.getValue());
                 }
                if(StringUtils.equalsIgnoreCase("familyName",cookie.getName())){
                    writer.key("familyName").value(cookie.getValue());
                 }
                if(StringUtils.equalsIgnoreCase("age",cookie.getName())){
                	writer.key("age").value(cookie.getValue());
                 }
                if(StringUtils.equalsIgnoreCase("birthday",cookie.getName())){
                    writer.key("birthday").value(cookie.getValue());
                 }
                
          }

       }
        writer.endObject();
    }

%>

        

<%

    Externalizer externalizer = sling.getService(Externalizer.class);
    XSSProtectionService xss = sling.getService(XSSProtectionService.class);
    boolean isDisabled = WCMMode.DISABLED.equals(WCMMode.fromRequest(slingRequest));
    Cookie[] cookies = request.getCookies();
    log.info("cookies::"+cookies);
    /*  start of cookies retrieving logic    */
   
    String displayName = "";
    String gender = "";
    String photo = "";
    String userId = "";
    String fName = "";
    String familyName = "";
    String aId = "";
    String age = "";
    String birthday ="";
    if(cookies != null) {
            for(Cookie cookie : cookies) {
            	log.info("cookie Name= "+cookie.getName()+"    cookie value= "+cookie.getValue());
            	if(StringUtils.equalsIgnoreCase("displayName",cookie.getName())){
                    displayName = cookie.getValue();
                    log.info("displayName::"+displayName);
                 }
            	if(StringUtils.equalsIgnoreCase("birthday",cookie.getName())){
            		birthday = cookie.getValue();
                    log.info("birthday::"+birthday);
                 }
            	if(StringUtils.equalsIgnoreCase("formattedName",cookie.getName())){
            		
            		fName = cookie.getValue();
                    log.info("formattedName::"+fName);
                    System.out.println("FNAME ***** "+ fName );
                 }
                if(StringUtils.equalsIgnoreCase("familyName",cookie.getName())){
                    
                	familyName = cookie.getValue();
                    log.info("familyName::"+displayName);
                 }
               // System.out.println("Photo :: "+ StringUtils.equalsIgnoreCase("photo",cookie.getName()));
                if(StringUtils.equalsIgnoreCase("photo",cookie.getName())){
                    photo = cookie.getValue();
                    photo =  URLDecoder.decode(photo, "UTF-8");
                    if(photo.contains("large")){
                    photo=photo.replace("large","small");
                    }
                    log.info("photo::"+photo);
                    //System.out.println("My pic" + photo);
                 }else if(StringUtils.equalsIgnoreCase("avatar",cookie.getName())){
                	 photo = cookie.getValue();
                	  log.info("avatar::"+photo);
                 }
                if(StringUtils.equalsIgnoreCase("gender",cookie.getName())){
                    gender = cookie.getValue();
                    log.info("gender::"+gender);
                 }
                if(StringUtils.equalsIgnoreCase("userId",cookie.getName())){
                    userId = cookie.getValue();
                 }
                if(StringUtils.equalsIgnoreCase("authorizableId",cookie.getName())){
                	aId = cookie.getValue();
                    log.info("authorizableId::"+aId);
                    if(null !=aId){
                    aId =  URLDecoder.decode(aId, "UTF-8");
                    }
                 }
                if(StringUtils.equalsIgnoreCase("age",cookie.getName())){
                    age = cookie.getValue();
                    log.info("age::"+age);
                 }
          }

    }
    String absoluteDefaultAvatar = "";
    if(externalizer != null){
        absoluteDefaultAvatar = externalizer.relativeLink(slingRequest, CollabUtil.DEFAULT_AVATAR);
    }

    StringWriter buf = new StringWriter();

    TidyJSONWriter writer = new TidyJSONWriter(buf);
    writer.setTidy(true);
    
    try {
        final UserPropertiesManager upm = slingRequest.getResourceResolver().adaptTo(UserPropertiesManager.class);
        setProfileInitialData(writer, upm, slingRequest, absoluteDefaultAvatar, xss,cookies);
    } catch (Exception e) {
        log.error("Error while generating JSON profile initial data", e);
    }

%>if (CQ_Analytics && CQ_Analytics.ProfileDataMgr) {
    CQ_Analytics.ProfileDataMgr.addListener("update", function(event, property) {
        var authorizableId = this.getProperty("authorizableId");
        if (!authorizableId || authorizableId == "anonymous") {

            $CQ(".cq-cc-profile-not-anonymous").hide();
            $CQ(".cq-cc-profile-anonymous").show();
        } else {
            $CQ(".cq-cc-profile-not-anonymous").show();
            $CQ(".cq-cc-profile-anonymous").hide();
        }
    });

    <%if (!isDisabled) { 
    %>
       
        CQ_Analytics.ProfileDataMgr.loadInitProperties({
            "authorizableId":"<%=aId%>",
            "formattedName":"<%=fName%>",
            "birthday":"<%=birthday%>",
            "displayName":"<%=displayName%>",
            "familyName":"<%=familyName%>",
            "gender":"<%=gender%>",
            "formattedName": CQ_Analytics.isUIAvailable ? CQ.I18n.getMessage("<%=fName%>") : "anonymous",
            "path": "/home/users",
            "avatar": "<%=photo%>"
            
            
        });
        CQ_Analytics.ClientContext.reset();
    <%} else {%>
        CQ_Analytics.ProfileDataMgr.loadInitProperties(<%=buf%>);
    <%}%>

    CQ_Analytics.ProfileDataMgr.init();
}
