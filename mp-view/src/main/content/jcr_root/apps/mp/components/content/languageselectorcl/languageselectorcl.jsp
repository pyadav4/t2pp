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

<script type="text/javascript">
        $(document).ready(function() {
            $('#languageSwitcher').languageSwitcher({ effect: 'fade', testMode:true         });
        });
    </script>

<script type='text/javascript'>//<![CDATA[ 
$(window).load(function(){ 
        $("#languageSwitcher ul li").hide();
        $("li."+$("#country").val()).show();
$(function() {
    $("#country").change(function() {
        $("[class^=country_]").each(function(){ $(this).hide();});
        $("."+$(this).val()).each(function(){ $(this).show();}); 
    }); 
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
    out.println("<select id=\"country\" name=\"country\" class=\"dropdown\">");
    for(Node countryNode : countryNodes){
    	if(defaultCountry != null && defaultCountry.equals(countryNode.getName())){
    		out.println("<option value=\"country_"+countryNode.getName()+"\" selected>"+countryNode.getProperty("jcr:content/jcr:title").getString()+"</option>");
    	}
    	else {
    		out.println("<option value=\"country_"+countryNode.getName()+"\">"+countryNode.getProperty("jcr:content/jcr:title").getString()+"</option>");	
    	}
    }
    out.println("</select>");
    
    // Generate style for flags to have in drop down. - Start
    out.println("<style type=\"text/css\">");
    for(Node countryNode : countryNodes){
        List<Node> languageSet = countryLanguageMap.get(countryNode);
        for(Node languageNode : languageSet){
            out.println(".country_"+countryNode.getName()+", #"+countryNode.getName()+"_"+languageNode.getName()+"{ background-image: url(/content/dam/mp/countryflags/"+countryNode.getName()+".png); background-repeat: no-repeat;background-position: 6px center;}")  ;
        }   
    }
    out.println("</style>");
    // Generate style for flags to have in drop down. - End
    
    out.println("<div id=\"languageSwitcher\"> <span>");
    out.println("<select id=\"-language-options\">");
    for(Node countryNode : countryNodes){
        List<Node> languageSet = countryLanguageMap.get(countryNode);
        for(Node languageNode : languageSet){
        	if(defaultLanguage != null && defaultLanguage.equals(languageNode.getName())){
        		out.println("<option id=\"" + countryNode.getName() + "_" + languageNode.getName() + "\" value=\"" + countryNode.getName() + "_" + languageNode.getName() + "\"  class=\"country_"+countryNode.getName()+"\" selected>" + languageNode.getProperty("jcr:content/jcr:title").getString()+"</option>");
            }
            else {
            	out.println("<option id=\"" + countryNode.getName() + "_" + languageNode.getName() + "\" value=\"" + countryNode.getName() + "_" + languageNode.getName() + "\"  class=\"country_"+countryNode.getName()+"\">" + languageNode.getProperty("jcr:content/jcr:title").getString()+"</option>");   
            }
        }   
    }
    out.println("</select>");
    out.println("</span></div>");
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
        $("#-language-options").val(langSelectedCl);
    }
    var countrySelectedCl = $.cookie("countrySelectedCl");
    if(countrySelectedCl != null){
        $("#region").val(countrySelectedCl);
    }   
});

function setLanguageInCookie(language) {
      $.cookie("langSelectedCl", language, {path: '/'});
    }
$( "#-language-options").change(function() {
	$.cookie("langSelectedCl", $( this ).val(), {path: '/'});
	});

$( "#region" ).change(function() {
    $.cookie("countrySelectedCl", $( this ).val(), {path: '/'});
    });

</script>