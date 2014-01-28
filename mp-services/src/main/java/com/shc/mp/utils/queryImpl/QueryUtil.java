package com.shc.mp.utils.queryImpl;

import java.util.ArrayList;
import java.util.List;

import javax.jcr.Node;
import javax.jcr.Property;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.Value;
import javax.jcr.query.InvalidQueryException;
import javax.jcr.query.Query;
import javax.jcr.query.QueryResult;
import javax.jcr.query.Row;
import javax.jcr.query.RowIterator;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ResourceResolverFactory;
import org.apache.sling.api.resource.ResourceUtil;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.apache.sling.jcr.api.SlingRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.shc.mp.utils.QueryService;

@Component(metatype = false, immediate = true)
@Service
public class QueryUtil implements QueryService {
	private final String RELATED_TAGS ="cq:tags";
	private static Logger log = LoggerFactory.getLogger(QueryUtil.class);
	  
	@Reference
	private SlingRepository slingRepository;
	  
	  /**
	  * This method is used to build the query 
	  * 
	  */
    public StringBuffer createQueryString(Resource resource, String geoPath, int offsetLimit, SlingScriptHelper sling) throws RepositoryException {
          //To check for the GEO
          StringBuffer sb=new StringBuffer();
          boolean isAndNeeded = false;
          
		  //GEO path will be considered once the site structure is decided
		  
          List<String> relatedTagList = fetchRelatedTag(resource);
		  sb.append("SELECT Path FROM [cq:PageContent] AS s WHERE ");
                     
          //Check for tags
          if(null !=relatedTagList && !relatedTagList.isEmpty()){
             if(isAndNeeded){
                  sb.append(" AND ");
             }
             isAndNeeded = true;
             sb.append("  CONTAINS([cq:tags],");
             sb.append("'");
             int relatedTagsCount=0;
             for(String primTag : relatedTagList ) {
                 sb.append(primTag);
                 //     
                 if(relatedTagsCount<relatedTagList.size()-1) {
                 sb.append(" OR ");
                 }
                 relatedTagsCount++;
             } 
             sb.append("'");
          }
		  //Closing tag
          if(null !=relatedTagList && !relatedTagList.isEmpty()){
              sb.append(" ) ");
          }
          
          log.info("######### query >> "+sb.toString());
          return sb;
     }
	 
	 /**
      * This method is used for building the related tags list
      * 
      */
     List<String> fetchRelatedTag(Resource resource) throws RepositoryException{
    	 String pagePath = resource.getPath();
    	 List<String> relatedTagList = new ArrayList<String>();
    	 Value[] propsList = null;
    	 if(null != resource ){
		     ResourceResolver rs= resource.getResourceResolver();
    		 ValueMap map = ResourceUtil.getValueMap(rs.getResource(pagePath));
    		 if(null!= map ){
    		    Property propObj = map.get(RELATED_TAGS,Property.class);
    		    if (propObj != null) {
                    if (propObj.isMultiple()) {
					    propsList = propObj.getValues();
                    }
                    else {
                        propsList = new Value[1];
                        propsList[0] = propObj.getValue();
                    }
                }
				if(null != propsList){
					for(Value v:propsList){
    		    	relatedTagList.add(v.getString());
					}
				}
    		    
    		 }
    	 }
    	 
         return relatedTagList;
     }
     
     
     
     /**
      * This method is used to executing the query and getting the results
      * 
      */
     public List<String> getSQL2QueryResults(Resource resource, String geoPath, int offsetLimit, SlingScriptHelper sling) throws InvalidQueryException, RepositoryException{
         long time1 = System.currentTimeMillis();
         StringBuffer sb = createQueryString(resource, geoPath, offsetLimit, sling);
         
         long time2 = System.currentTimeMillis();
         log.info("Time taken to execute the query >> "+(time2-time1));
         
         List<String> sList=new ArrayList<String>();
         Session session = getJcrSession();
         ResourceResolver adminRR = null;
         try {
             Query query = session.getWorkspace().getQueryManager().createQuery(sb.toString(), javax.jcr.query.Query.JCR_SQL2);
            
             query.setLimit(offsetLimit);
             QueryResult results=query.execute();
             RowIterator ri=results.getRows();
             ResourceResolverFactory resourceResolverFactory= sling.getService(ResourceResolverFactory.class);
             adminRR = resourceResolverFactory.getAdministrativeResourceResolver(null); 
             while(ri.hasNext()){
				 Row rw=ri.nextRow();
                 String path = rw.getPath();
				 if(adminRR.getResource(path) != null){
                     javax.jcr.Node node = adminRR.getResource(path).adaptTo(Node.class);
                     if(node.hasNode("jcr:content")){
                         node = node.getNode("jcr:content");                         
                     }
                  }
                 if(path != null && path.contains("jcr:content")){
                     path = path.substring(0,path.lastIndexOf("/"));
                     sList.add(path);
                 }
               }
             
         }catch(Exception e) {
				e.printStackTrace();
        	    log.error("Error  :::"+e.getMessage());
         }
         finally {
           if(null != adminRR) {
               adminRR.close();
           }
           if(session != null ) {
                 session.logout();
           }
         }
         log.info("query final operation hhhh>> "+(System.currentTimeMillis()-time1));
         log.info("sList.size() >>>>>>>>>>>>>>>>>>>>>>>>>>> " +sList.size());
         return sList;
     }
	 /**
      * This method is used to create the Session object
      * 
      */
     public Session getJcrSession() {
 		Session jcrSession = null;
 		try {
 			jcrSession = slingRepository.loginAdministrative(null);
 		} catch (RepositoryException e) { 
 			log.error("RepositoryException :: " + e.getMessage());
 		}
 		return jcrSession;
 	}

}
