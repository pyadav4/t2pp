<%@include file="/libs/foundation/global.jsp" %>
<%@page contentType="text/html" pageEncoding="utf-8"
            import=" com.shc.mp.utils.BannerUtil, java.util.List, com.shc.mp.beans.BCBean,
             com.shc.mp.utils.QueryService, com.day.cq.wcm.api.WCMMode" %>
            
     
            
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
       <div class="panelList">
           <c:forEach items="${bannersList}" var="slide">
                <article class="panel generic">
                    <div class="panelWrapper">
                        <div class="details">
                            <div class="wrapper">
                                <div class="intro">
                                    <em>${slide.pageSubTitle}</em>
                                </div>
                                <header>
                                    <h1>${slide.pageTitle}</h1>
                                </header>
                                <ul>
                                    <li> 
                                        <div class="button primary">
                                            <a href="${slide.pagePath}.html" >learn more</a>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="hero-img">
                            <img src="${slide.image}" />
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>
    <div class="next icon"><span>&#x2192;</span></div>
    <div class="prev icon"><span>&#x2190;</span></div>
    <div class="bullet-pagination icon"></div>
    </c:otherwise> 
</c:choose>
