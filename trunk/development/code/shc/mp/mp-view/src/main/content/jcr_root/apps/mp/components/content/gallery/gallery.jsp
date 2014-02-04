<%@include file="/libs/foundation/global.jsp"%>
<%@page import="javax.jcr.query.Query"%>
<%@page import="javax.jcr.query.Row"%>
<%@page import="javax.jcr.query.RowIterator"%>
<%@page import="javax.jcr.query.QueryResult"%>

<script type="text/javascript">
function popUpBox() { 
    Shadowbox.setup("a.group", {
        gallery:        "group",
        continuous:     true,
        counterType:    "skip"
    });

    Shadowbox.setup('a[title="The Last Eggtion Hero"]', {
        height:     360,
        width:      640,
        flashVars:  {
            clip_id:    "1893986",
            autoplay:   "1"
        }
    });
}

Shadowbox.init({
    // a darker overlay looks better on this particular site
    overlayOpacity: 0.6
}, popUpBox);
</script>

<ul class="gallery grid">
<%
Session session = resource.getResourceResolver().adaptTo(Session.class); 
Query query = session.getWorkspace().getQueryManager().createQuery("SELECT * FROM [dam:Asset] AS s WHERE ISDESCENDANTNODE([/content/dam/geometrixx/travel])", javax.jcr.query.Query.JCR_SQL2);

//query.setLimit(offsetLimit);
QueryResult results=query.execute();
NodeIterator ni=results.getNodes();
while(ni.hasNext()){
    Node node = ni.nextNode();
    String nodePath = node.getPath();
    String nodeName = node.getName();
    nodeName = nodeName.substring(0,nodeName.indexOf("."));
%>
<li><a class="group" href="<%=nodePath %>" title="<%=nodeName%>" ><img  src="<%=nodePath %>.thumb.100.140.png" alt="" ></a><h2><%=nodeName %></h2></li>    
<%
    //out.println("path :: "+path);
}
%>
</ul>