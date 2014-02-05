<%@include file="/libs/foundation/global.jsp"%>
<cq:includeClientLib categories="mp.languageselectorcl"/>
<%currentDesign.writeCssIncludes(pageContext); %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="org.apache.sling.api.resource.ResourceResolver"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<script type='text/javascript'>//<![CDATA[ 
$(function() {   
    $("#language option").hide();  
    $("#language ."+$('#country').val()).each(function(){ $(this).show();});  
    
    $("#country").change(function() { 
        $("[class^=country_]").each(function(){ $(this).hide();});
        $("."+$(this).val()).each(function(){ $(this).show();});  
        $('#language').find("option:visible:first")[0].selected = true;
        $.cookie("countrySelectedCl", $( this ).val(), {path: '/'});
        $.cookie("langSelectedCl", $( "#language").val(), {path: '/'});
    }); 
});//]]>  

</script>

    <%
    String websiteRoothPath = currentStyle.get("websiterootpath","/content/mpcl");
    String websiteLanguagePath = currentStyle.get("defaultlanguage","");
    LanguageSelector languageSelector = new LanguageSelector();
    Map<Node, List> countryLanguageMap = languageSelector.getLanguageSelector(resourceResolver,websiteRoothPath);
    Set<Node> countryNodes = countryLanguageMap.keySet();
    String defaultCountry = languageSelector.getDefaultCountry(resourceResolver,websiteLanguagePath);
    String defaultLanguage = languageSelector.getDefaultLanguage(resourceResolver,websiteLanguagePath);
    out.println("<select id=\"country\" name=\"country\" >");
    for(Node countryNode : countryNodes){
    	if(defaultCountry != null && defaultCountry.equals(countryNode.getName())){
    		out.println("<option value=\"country_"+countryNode.getName()+"\" selected>"+countryNode.getProperty("jcr:content/jcr:title").getString()+"</option>");
    	}
    	else {
    		out.println("<option value=\"country_"+countryNode.getName()+"\">"+countryNode.getProperty("jcr:content/jcr:title").getString()+"</option>");	
    	}
    }
    out.println("</select>");
    
    out.println("<select id=\"language\">");
    for(Node countryNode : countryNodes){
        List<Node> languageSet = countryLanguageMap.get(countryNode);
        for(Node languageNode : languageSet){
        	if(defaultLanguage != null && defaultLanguage.equals(languageNode.getName())){
        		out.println("<option value=\"" + countryNode.getName() + "_" + languageNode.getName() + "\"  class=\"country_"+countryNode.getName()+"\" selected>" + languageNode.getProperty("jcr:content/jcr:title").getString()+"</option>");
            }
            else {
            	out.println("<option value=\"" + countryNode.getName() + "_" + languageNode.getName() + "\"  class=\"country_"+countryNode.getName()+"\">" + languageNode.getProperty("jcr:content/jcr:title").getString()+"</option>");   
            }
        }   
    }
    out.println("</select>");
    %>
<br>
<%!
 public class LanguageSelector {
    public Map<Node, List> getLanguageSelector(ResourceResolver resourceResolver, String websiteRootPath) {
        //System.out.println("inside getLanguageSelector :: "+resourceResolver);
        Map<Node, List> countryLanguageMap = null; 
        List<Node> countrySet = null;
         Node websiteRootNode = resourceResolver.getResource(websiteRootPath).adaptTo(Node.class);
         if(websiteRootNode!=null){
             try{
            	 countryLanguageMap = new HashMap<Node, List>();
            	 countrySet = getNodeSet(websiteRootNode);
                 for(Node country: countrySet){
                	 List<Node> languageSet = null;
                     languageSet = getNodeSet(country);
                     countryLanguageMap.put(country,languageSet);
                 }
                 }catch(RepositoryException repositoryException){
                     System.out.println("repositoryException :: "+repositoryException);
                 } 
         }
         return countryLanguageMap;
    }
     
     private List<Node> getNodeSet(Node nodeToIterate)throws RepositoryException{
         //System.out.println("inside getNodeSet :: ");
         List<Node> nodeSet = null;
         if(nodeToIterate.hasNodes()) {
            nodeSet = new ArrayList<Node>();
            NodeIterator ni = nodeToIterate.getNodes();
            while(ni.hasNext()){
                Node node = ni.nextNode();
                if(!node.getName().equals("jcr:content")){
                    nodeSet.add(node);  
                }
            }
         }
         return nodeSet;
     }
     
     public String getDefaultCountry(ResourceResolver resourceResolver, String path) {
    	//System.out.println("inside getLanguageSelector :: "+resourceResolver);
        String defaultCountry = null;
        Resource resource = resourceResolver.getResource(path);
        if(resource!=null){  
            Node languageNode = resource.adaptTo(Node.class);
            try{
          	  defaultCountry = languageNode.getParent().getName();    
            }catch(RepositoryException repositoryException){
                System.out.println("repositoryException :: "+repositoryException);
                defaultCountry = null;
            } 
          }
          return defaultCountry;
     }
     
     public String getDefaultLanguage(ResourceResolver resourceResolver, String path) {
         //System.out.println("inside getLanguageSelector :: "+resourceResolver);
         String defaultLanguage = null;
         Resource resource = resourceResolver.getResource(path);
         if(resource!=null){
       	    Node languageNode = resource.adaptTo(Node.class);
            try{
         	   defaultLanguage = languageNode.getName();    
            }catch(RepositoryException repositoryException){
               System.out.println("repositoryException :: "+repositoryException);
               defaultLanguage = null;
            } 
         }
         return defaultLanguage;
      }
 }
%>

<script type="text/javascript">
$(document).ready(function(){
    
    var langSelectedCl = $.cookie("langSelectedCl");
    if(langSelectedCl != null){
        $("#language").val(langSelectedCl);
    }
    else {
    	$.cookie("langSelectedCl", $( "#language").val(), {path: '/'});
    }
    var countrySelectedCl = $.cookie("countrySelectedCl");
    if(countrySelectedCl != null){
        $("#country").val(countrySelectedCl);
    }
    else {
    	$.cookie("countrySelectedCl", $( "#country" ).val(), {path: '/'});
    }   
});

</script>