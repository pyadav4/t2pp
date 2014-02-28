package com.shc.mp.utils;

import java.io.IOException;
import java.util.Iterator;

import javax.servlet.ServletException;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Component(immediate = true, description = "StoreData")
@Service(value = javax.servlet.Servlet.class)
@Properties(value = {
        @Property(name = "sling.servlet.extensions", value = { "html" }),
        @Property(name = "sling.servlet.methods", value = { "GET" }),
        @Property(name = "sling.servlet.paths", value = { "/libs/datastore" })
})
public class StoreDataServlet extends SlingAllMethodsServlet {

               private static final long serialVersionUID = 1L;
               private Logger log = LoggerFactory.getLogger(StoreDataServlet.class);
               
  
               /* (non-Javadoc)
             * @see org.apache.sling.api.servlets.SlingAllMethodsServlet#doPost(org.apache.sling.api.SlingHttpServletRequest, org.apache.sling.api.SlingHttpServletResponse)
             */
            protected void doPost(SlingHttpServletRequest request,
                                             SlingHttpServletResponse response) throws ServletException,
                                             IOException {
             	ResourceResolver resR = request.getResourceResolver();
            	
            	JSONArray jsonArr = new JSONArray();
            	String res = request.getRequestPathInfo().getSuffix()+"/jcr:content/parsys";
            	if(resR.getResource(res)!=null) {
            		if(resR.getResource(res).listChildren()!=null) {
		            	Iterator<Resource> resIterator = resR.getResource(res).listChildren();
		            	while(resIterator.hasNext()) {
		            		JSONObject obj = new JSONObject();
		            		Resource item = resIterator.next();
		            		ValueMap itemNode = item.adaptTo(ValueMap.class);
		            		try {
								if(itemNode.containsKey("name") && itemNode.containsKey("longitude") && itemNode.containsKey("latitude")) {							
									obj.put("storeName", itemNode.get("name"));
									obj.put("longitude", itemNode.get("longitude"));
									obj.put("latitude", itemNode.get("latitude"));							
								}
								
									obj.put("address", itemNode.get("address",""));
									obj.put("state", itemNode.get("state",""));
									obj.put("country", itemNode.get("state",""));
									obj.put("phonenumber", itemNode.get("phonenumber",""));
									obj.put("promotionaltext", itemNode.get("promotionaltext",""));
									obj.put("email", itemNode.get("email",""));
									
								jsonArr.add(obj);
								
							} catch (Exception e) {
								log.error(e.getMessage());
							}
	            	}
	            	
	            	response.setContentType("application/json");
	            	response.getWriter().write(jsonArr.toString());
	        	}	
            	}
            }

               /* (non-Javadoc)
             * @see org.apache.sling.api.servlets.SlingSafeMethodsServlet#doGet(org.apache.sling.api.SlingHttpServletRequest, org.apache.sling.api.SlingHttpServletResponse)
             */
            @Override
               protected void doGet(SlingHttpServletRequest request,
                                             SlingHttpServletResponse response) throws ServletException,
                                             IOException {
            	   doPost(request,response);
               }

}
