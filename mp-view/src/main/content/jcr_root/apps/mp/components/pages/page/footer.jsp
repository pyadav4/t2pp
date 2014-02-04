<%@include file="/libs/foundation/global.jsp" %>
<div>

</div>
<script type="text/javascript" src="/etc/clientlibs/mac/jquery-cookie/source/jquery.cookie.js" >
</script>
<script>
$(document).ready(function() {


    
   
    if($.cookie("history")==null){
        $.cookie("history",100000000,{ path: '/' });
    }
    var number=0;
    number=+$.cookie("history");
    
    <%
    Value[] labels= null;
    if(currentNode.hasProperty("cq:tags")){
    	Property  categoryProperty = currentNode.getProperty("cq:tags"); 
    	if(categoryProperty.isMultiple()){
            labels = categoryProperty.getValues();
            
         }
    }
    if(null != labels){
    for(Value label:labels) { %>
    var lb ='<%=label.getString()%>';
    if(lb.indexOf("forum") == 0){
        number=number+1000000;
        $.cookie("history",number,{ path: '/' });
    } else if(lb.indexOf("stockphotography") == 0){
        number+=10000;
        $.cookie("history",number,{ path: '/' });
    } else if(lb.indexOf("marketing") == 0){
        number+=100;
        $.cookie("history",number,{ path: '/' });
     } else  if (lb.indexOf("facebook") == 0){
        number+=1;
        $.cookie("history",number,{ path: '/' });
      }
    
    
   <% } }%>   
 
});
</script>