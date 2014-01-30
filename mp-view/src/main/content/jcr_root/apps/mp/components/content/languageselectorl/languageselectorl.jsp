<%@include file="/libs/foundation/global.jsp"%>
<cq:includeClientLib categories="mp.languageselectorl"/>
<%currentDesign.writeCssIncludes(pageContext); %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="org.apache.sling.api.resource.ResourceResolver"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

    <%
    String websiteRoothPath = currentStyle.get("websiterootpath","/content/mpl");
    String websiteLanguagePath = currentStyle.get("defaultlanguage","en_us");
    LanguageSelector languageSelector = new LanguageSelector();
    List<Node> languageList = languageSelector.getLanguageSelector(resourceResolver,websiteRoothPath);
    String defaultLanguage = languageSelector.getDefaultLanguage(resourceResolver,websiteLanguagePath);
    out.println("<div class=\"lang-menu\">");
    out.println("<ul>");
    for(Node languageNode : languageList){
       out.println("<li><a onclick=\"setLanguageInCookie('"+languageNode.getName()+"')\" href=\""+languageNode.getPath()+".html\" id=\"#\">"+languageNode.getProperty("jcr:content/jcr:title").getString()+"</a></li>")  ;
    }
    out.println("</ul>");
    out.println("</div>");
    %>
    <script type="text/javascript">
    function setdefaultLanguage(language) {
        var langSelected = $.cookie("langSelectedL");
        if(langSelected == null) {
            $.cookie("langSelectedL", language, {path: '/'});
        }
      }
       setdefaultLanguage('<%=defaultLanguage%>');
    </script>
<br>
<%!
 public class LanguageSelector {
    public List<Node> getLanguageSelector(ResourceResolver resourceResolver, String websiteRootPath) {
        List<Node> languageList = null;
         Node websiteRootNode = resourceResolver.getResource(websiteRootPath).adaptTo(Node.class);
         if(websiteRootNode!=null){
             try{
            	 languageList = getNodeSet(websiteRootNode);
             }
             catch(RepositoryException repositoryException){
                 System.out.println("repositoryException :: "+repositoryException);
             } 
         }
         return languageList;
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

	function setLanguageInCookie(language) {
	      $.cookie("langSelectedL", language, {path: '/'});
	    }
</script>
