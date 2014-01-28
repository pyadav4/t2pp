<%@include file="/libs/foundation/global.jsp"%>
<%@page import="com.day.cq.wcm.api.WCMMode,javax.jcr.Property" %>
<cq:defineObjects />
<cq:includeClientLib categories="cq-customtags"/>
<%
%><%
	
    String operator = properties.get("operator", "");
	String pageCount = properties.get("number", "");
     if(currentNode != null && currentNode.hasProperty("selectCategory")) {
    	    Property  categoryProperty = currentNode.getProperty("selectCategory"); 
    	    String label ="";
    	    if(categoryProperty.isMultiple()){
    	        Value[] labels = categoryProperty.getValues();
    	        if(labels.length >0){
    	        	 label = labels[0].getString();
    	        }
    	       
    	    }
        %><%=label %>  &nbsp;&nbsp;&nbsp;&nbsp;    pagecount
        &nbsp;&nbsp;&nbsp;
        <%= operator %>&nbsp;&nbsp;&nbsp;
        <%= pageCount %>&nbsp;&nbsp;
        <%
    }

    else if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><img src="/libs/cq/ui/resources/0.gif" class="cq-teaser-placeholder" alt=""/><%
    }
%>
<script src="/etc/designs/ada-designs/author-libs/jquery.cookie.js"></script>
