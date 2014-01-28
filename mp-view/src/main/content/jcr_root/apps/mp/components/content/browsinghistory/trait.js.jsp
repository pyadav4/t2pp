<%@include file="/libs/foundation/global.jsp"%>
<%@page import="javax.servlet.http.Cookie,javax.jcr.Property"%>
<%
String label ="";
if(currentNode.hasProperty("selectCategory")){
    Property  categoryProperty = currentNode.getProperty("selectCategory"); 
    if(categoryProperty.isMultiple()){
        Value[] labels = categoryProperty.getValues();
        if(labels.length >0){
            label = labels[0].getString();
       }
    }
}

    
    
    int pageCount = Integer.parseInt(properties.get("number", "0"));
    String operator = properties.get("operator", "");
    Cookie[] cookies = request.getCookies();
    String returnval = "false";
    String countOfPages = "0";
    if (cookies != null) {
         for (Cookie cookie : cookies) {
           if (cookie.getName().equals("history")) {
               countOfPages = cookie.getValue();
           }
         }
        if(countOfPages.equals("0")){
            countOfPages="100000000";
        }
    }
    else{
            countOfPages="100000000";
    }

    int i=0,j=0;
    if(label.indexOf("forum") == 0){
        i=1;j=2;
    }
    else if (label.indexOf("stockphotography") == 0){
        i=3;j=4;
    }
    else if (label.indexOf("marketing") == 0){
        i=5;j=6;
    }
    else if (label.indexOf("facebook") == 0){
        i=7;j=8;
    }
    
    String countOfPagesTemp=""+countOfPages.charAt(i)+countOfPages.charAt(j);
    int cookieCountOfPages=Integer.parseInt(countOfPagesTemp);
    if("greaterthan".equals(operator)){
        if(cookieCountOfPages>pageCount){
            returnval = "true";
        }
    }
    else if("lessthan".equals(operator)){
         if(cookieCountOfPages < pageCount){
             returnval="true";
        }
    
    }
    else if("equals".equals(operator)){
        if(cookieCountOfPages == pageCount){
            returnval="true";
        }
    }
%>
<%=returnval%>