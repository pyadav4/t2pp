package com.shc.mp.utils;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import javax.jcr.Node;
import javax.jcr.Property;
import javax.jcr.RepositoryException;
import javax.jcr.Value;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.scripting.SlingScriptHelper;

import com.day.cq.wcm.api.Page;
import com.shc.mp.beans.BCBean;

public class BannerUtil {

    private final String RELATED_TAGS ="cq:tags";
    private final String REQUIRED_CONTENT ="requiredcontent";
    private final String EXCLUDED_CONTENT ="excludedcontent";
    private final String JCRCONTENT_NODE ="jcr:content";
    
    
	/**
      * This method is used to return the value of a Property
      * 
      */
    public List<String> getPropertyValue(Node currentNode, String propertyName) throws RepositoryException{
        List<String> propsList = new ArrayList<String>();
        Property property = null;
        if(null != currentNode && currentNode.hasProperty(propertyName)){
            property = currentNode.getProperty(propertyName);
            if(null != property){
                if (property != null) {
                    if (property.isMultiple()) {
                        for(Value v:property.getValues()){
                            propsList.add(v.getString());
                        }
                    }
                    else {
                        propsList.add(property.getValue().getString());
                    }
                }
            }
        }
        return propsList;
    }   
    /**
      * This method is used for creating the List of bean objects  
      * 
      */    
    public List<BCBean> getResults(Node currentNode, Page page, Resource resource, SlingScriptHelper sling) throws RepositoryException{
        List<BCBean> result = new ArrayList<BCBean>();
        Property property = null;
        if( null != currentNode && currentNode.hasProperty(RELATED_TAGS)){
            property= currentNode.getProperty(RELATED_TAGS);
        } else {
            Resource rs= resource.getResourceResolver().getResource(page.getPath());
            if(null != rs){
                Node pageNode = rs.adaptTo(Node.class);
                if(null != pageNode && pageNode.hasNode(JCRCONTENT_NODE)){
                    pageNode= pageNode.getNode(JCRCONTENT_NODE);
                }
                if(null != pageNode && pageNode.hasProperty(RELATED_TAGS)){
                    property= pageNode.getProperty(RELATED_TAGS);
                }
            }
        }
        // check for property and convert it into list
        List<String> propsList = new ArrayList<String>();
        if(null != property){
            if (property != null) {
                if (property.isMultiple()) {
                    for(Value v:property.getValues()){
                        propsList.add(v.getString());
                    }
                }
                else {
                    propsList.add(property.getValue().getString());
                }
            }
        }
        
        List<String> list = new java.util.LinkedList<String>();
		List<String> ddList = new java.util.LinkedList<String>();
		if(propsList.size() >0){
			QueryService qu = sling.getService(QueryService.class);
			if(null != qu){
				ddList =qu.getSQL2QueryResults(resource, page.getPath(), 10, sling);
			}
		}
        
        List<String> requiredList =getPropertyValue(currentNode, REQUIRED_CONTENT);
        List<String> excludeList = getPropertyValue(currentNode, EXCLUDED_CONTENT);
        list.addAll(requiredList);
        if(null !=  propsList && propsList.size()>0 || list.size() >0){
            removeCurrentPageFromList(ddList,page.getPath());
                list.addAll(ddList);
                
            for(String s:excludeList){
                if(list.contains(s.replaceAll(".html",""))){
                    list.remove(s.replaceAll(".html",""));
                }
            }
            Set<String> hashSet = new LinkedHashSet<String>();
            hashSet.addAll(list);
            String resultantPath= null;
            Resource rsc= null;
            for(String st:hashSet){
                resultantPath = st;
                BCBean bean = new BCBean();
                rsc= resource.getResourceResolver().getResource(resultantPath);
                if(null != rsc){
                    Node pageNode = rsc.adaptTo(Node.class);
                    if(pageNode != null && pageNode.hasNode("jcr:content")){
                        pageNode = pageNode.getNode("jcr:content");
                    }
                    bean.setPagePath(pageNode.getParent().getPath());
                    
                    if(null != pageNode && pageNode.hasNode("image") && pageNode.getNode("image").hasProperty("fileReference")){
                        String image = pageNode.getNode("image").getProperty("fileReference").getString();
                        bean.setImage(image);
                    }
                    if(pageNode.hasProperty("jcr:description")){
                        String desc = pageNode.getProperty("jcr:description").getString();
                        bean.setPageDescription(desc);
                    } 
                    if(pageNode.hasProperty("jcr:title")){
                        String title = pageNode.getProperty("jcr:title").getString();
                        bean.setPageTitle(title);
                    } 
                    if(pageNode.hasProperty("subtitle")){
                        bean.setPageSubTitle(pageNode.getProperty("subtitle").getString());
                    }
                    result.add(bean);
                }
            }
        }
        return result;
    }
    /**
      * This method is used to remove the current page from the search results
      * 
      */
    private void removeCurrentPageFromList(List<String> list, String path) {
        if(list != null && list.size()>0){
            list.remove(path);
        }
    }
    
}

