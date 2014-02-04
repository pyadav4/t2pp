<%@include file="/libs/foundation/global.jsp" %>
<%@page contentType="text/html" pageEncoding="utf-8"
            import=" com.shc.mp.utils.BannerUtil, java.util.List, com.shc.mp.beans.BCBean,
             com.shc.mp.utils.QueryService, com.day.cq.wcm.api.WCMMode" %>
            
     
<cq:includeClientLib  categories="cq-banner"/>          
Advertisement
<%
BannerUtil bc = new BannerUtil();
List<BCBean> list =bc.getResults(currentNode, currentPage, resource, sling) ;
pageContext.setAttribute("bannersList",list); 
pageContext.setAttribute("prop",currentNode.hasProperty("cq:tags")); 
pageContext.setAttribute("wcmEditMode",WCMMode.fromRequest(request)==WCMMode.EDIT); 
%>
    
    <c:choose>
    <c:when test="${wcmEditMode && (fn:length(list) == 0) && !prop } ">
        <img src="/libs/cq/ui/resources/0.gif" class="cq-table-placeholder" alt="Banner Carousel" title="Banner Carousel" />
    </c:when>
    <c:otherwise>
        <div id="slider-images">
    <div> </div>
  </div>
  <div id="slider" class="clearfix"> 
  <c:forEach items="${bannersList}" var="slide">
    <div class="slider-item on" rel="${slide.image}">
      <h2> <span class="yellow">${slide.pageTitle}</span> <span class="red">${slide.pageSubTitle}</span>
        
        <a target="_blank" class="btn-cta-play" href="${slide.pagePath}.html"><span><i>Learn More</i></span></a> </h2>
    </div>
  </c:forEach>
  <a href="" id="btn-sliderleft"><span></span></a> <a href="" id="btn-sliderright"><span></span></a> 
  </div>
    </c:otherwise> 
</c:choose>




 