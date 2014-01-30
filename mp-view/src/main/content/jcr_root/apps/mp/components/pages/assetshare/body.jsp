<%@include file="/libs/foundation/global.jsp" %><%
    StringBuffer cls = new StringBuffer();
    for (String c: componentContext.getCssClassNames()) {
        cls.append(c).append(" ");
    }
%><body class="<%= cls %>">
<cq:include path="clientcontext" resourceType="cq/personalization/components/clientcontext"/>
    <div>
        <cq:include script="content.jsp"/>
    </div>
</body>