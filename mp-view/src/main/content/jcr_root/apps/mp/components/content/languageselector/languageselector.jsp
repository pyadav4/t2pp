<%@include file="/libs/foundation/global.jsp"%>
<cq:includeClientLib categories="mp.languageselector"/>
<%currentDesign.writeCssIncludes(pageContext); %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="org.apache.sling.api.resource.ResourceResolver"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<div class="lang right top"> <span id="selectedLanguage" class="btn">India(English)</span>
  <div class="links" style="display:none ;">
	<%
	String websiteRoothPath = currentStyle.get("websiterootpath","/content/mp");
	LanguageSelector languageSelector = new LanguageSelector();
	Map<Node, Map> languageSelectorMap = languageSelector.getLanguageSelector(resourceResolver,websiteRoothPath);
	Set<Node> regionNodes = languageSelectorMap.keySet();
	for(Node regionNode : regionNodes){
		//out.println("Region Node:: " +regionNode.getName());
		out.println("<div class=\"columns\">");
		out.println("<div class=\"title\">" +regionNode.getProperty("jcr:content/jcr:title").getString()+"</div>");
		Map<Node, List> countryLanguageMap = languageSelectorMap.get(regionNode);
		Set<Node> countryNodes = countryLanguageMap.keySet();
		for(Node countryNode : countryNodes){
		    //out.println("Country Node:: " +countryNode.getName());
		    List<Node> languageSet = countryLanguageMap.get(countryNode);
		    for(Node languageNode : languageSet){
		    	out.println("<a onClick=\"setLanguageInCookie('"+countryNode.getProperty("jcr:content/jcr:title").getString()+" ("+languageNode.getProperty("jcr:content/jcr:title").getString()+")')\" href=\""+languageNode.getPath()+".html\">" +countryNode.getProperty("jcr:content/jcr:title").getString()+" ("+languageNode.getProperty("jcr:content/jcr:title").getString()+")</a>");
	            //out.println("Language Node:: " +languageNode.getName());
	        }   
		}
		out.println("</div>");
	}
	%>
  </div>
</div>
<br>
<%!

 public class LanguageSelector {
     
    public Map<Node, Map> getLanguageSelector(ResourceResolver resourceResolver, String websiteRootPath) {
    	//System.out.println("inside getLanguageSelector :: "+resourceResolver);
    	Map<Node, Map> regionCountryMap = new HashMap<Node, Map>();
        Map<Node, List> countryLanguageMap = null; 
    	List<Node> regionSet = null;
         Node websiteRootNode = resourceResolver.getResource(websiteRootPath).adaptTo(Node.class);
         if(websiteRootNode!=null){
        	 try{
                 regionSet = getNodeSet(websiteRootNode);
                 List<Node> countrySet = null;
                 for(Node region: regionSet){
                     countryLanguageMap = new HashMap<Node, List>();
                     countrySet = getNodeSet(region);
                     for(Node country: countrySet){
                         List<Node> languageSet = null;
                         languageSet = getNodeSet(country);
                         countryLanguageMap.put(country,languageSet);
                     }
                     regionCountryMap.put(region,countryLanguageMap);
                 }
                 }catch(RepositoryException repositoryException){
                     System.out.println("repositoryException :: "+repositoryException);
                 } 
         }
         
         return regionCountryMap;
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
 }
%>

<script type="text/javascript">
$(document).ready(function(){
    $(".lang .btn").click(function(){
        $(".lang .links").slideToggle();
        $( this ).toggleClass( "selected" );
    });
    var langSelected = $.cookie("languageSelected");
    if(langSelected != null){
    	$("#selectedLanguage").html(langSelected);
    }   
});

function setLanguageInCookie(language) {
	  $.cookie("languageSelected", language, {path: '/'});
	}
</script>