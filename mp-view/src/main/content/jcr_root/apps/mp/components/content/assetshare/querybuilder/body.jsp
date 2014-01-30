<%@page session="false" contentType="text/html; charset=utf-8"%>
<%@ page import="org.apache.sling.api.SlingException,
                     com.day.cq.wcm.api.WCMMode"
%><%@include file="/libs/foundation/global.jsp"%><%

    String textResults = properties.get("textResults", "Results");
    String textPage = properties.get("textPage", "Page");
    String textOf = properties.get("textOf", "of");

    String feedUrl = properties.get("feedUrl", "/bin/querybuilder.feed");
    String limit = properties.get("limit", "24");
    String[] paths = properties.get("path", String[].class);
    if (paths == null) {
        paths = new String[]{"/content/dam"};
    }
    String[] types = properties.get("type", String[].class);
    if (types == null) {
        types = new String[]{"dam:Asset"};
    }
    String actionsTitle = properties.get("actionsTitle", "Actions");
    String editorPath = properties.get("editorPath", "./asseteditor");
    try {
        if (editorPath.indexOf(".") == 0) {
            // relative path
            editorPath = resource.getResourceResolver().getResource(currentPage.adaptTo(Resource.class), editorPath).getPath();
        }
        else {
            // absolute path
            editorPath = resource.getResourceResolver().getResource(editorPath).getPath();
        }
    }
    catch (Exception e) {
        // editor does not exist
        editorPath = null;
    }
    if (editorPath == null) editorPath = "";

    // disabled for 5.3 load 13
//    String topPredicatesHeight = properties.get("topPredicatesHeight", null);
    String topPredicatesHeight = null;
    if (topPredicatesHeight != null) {
        // default of 100px is set in static.css
%><style type="text/css">
    .assetshare .top-predicates .section {
        height:<%= topPredicatesHeight %>px;
    }

</style><%
    }
%><%
    if (WCMMode.fromRequest(request) == WCMMode.EDIT && !editorPath.equals("")) {
        %><a href="<%= editorPath %>.html" class="hideInPreview" style="font-style:italic;">Go to assigned Asset Editor</a><%
    }
%><table class="wrapper"><tbody>

    <%-- disabled for 5.3 load 13 --%>
    <%--<tr><td colspan="2">--%>
        <%--<div class="top-predicates">--%>
            <%--<cq:include path="top" resourceType="foundation/components/parsys" />--%>
        <%--</div>--%>
    <%--</td></tr>--%>


    <%-- grey bar containing text search field, paging and lens buttons --%>
    <tr><td colspan="2" class="line_gray" id="prebar"></td></tr>
    <tr><td colspan="2" class="bar-cell">
        <table class="bar"><tbody><tr>

            <td id="fulltext-cell"></td>

            <%--todo: text (results/page of) from content--%>
            <td id="results-cell" style="visibility:hidden;"><span id="results"></span>&nbsp;<%= textResults %></td>

            <td id="paging-cell">
                <%-- wrapper is required in IE (display does not work properly with the cell) --%>
                <span id="paging-wrapper" style="display:none;">
                    <span id="backward" onclick="CQ.search.Util.getQueryBuilder().lastPage();">&laquo;</span><!--
                    -->&nbsp;<%= textPage %>&nbsp;<span id="current-page"></span>&nbsp;<%= textOf %>&nbsp;<span id="total-pages"></span><!--
                    -->&nbsp;<span id="forward" onclick="CQ.search.Util.getQueryBuilder().nextPage();">&raquo;</span>
                </span>
            </td>

            <td class="buttons-cell">
                <%-- render lenses parsys here and use buttons as editables--%>
                <script type="text/javascript">
                    CQ.Ext.onLoad(function() {
                        var data = {
                            "xtype": "lensdeck",
                            "cls": "lensdeck",
                            "renderTo": "lensdeck-wrapper",
                            "id": "lensdeck"
                        };
                        CQ.dam.Util.setAssetEditorPath("<%= editorPath %>");
                        CQ.search.Util.setLensContainer(CQ.Util.build(data));
                        CQ.search.Util.setDblClickAction(CQ.dam.Util.resultDblClick);
                    });

                </script>
                <cq:include path="../lenses" resourceType="foundation/components/parsys" />
            </td>
        </tr></tbody></table>
    </td></tr>
    <tr><td colspan="2" class="line postbar"></td></tr>

    <tr>
        <td class="left-cell">
            <%-- predicates are rendered one by one (ext) >> hide to render and display onload (see below) --%>
            <div id="left-cell-content" style="display:none;">
                <div class="left-predicates">
                    <cq:include path="left" resourceType="foundation/components/parsys" />
                </div>
                <div class="actions">
                    <div class="title"><%= actionsTitle %></div>
                    <cq:include path="../actions" resourceType="foundation/components/parsys" />
                </div>
            </div>
        </td>
        <td class="lensdeck-cell">
            <%-- lenses will be rendered into lensdeck-wrapper--%>
            <div id="lensdeck-wrapper" class="lensdeck-wrapper"></div>
        </td>
    </tr>

</tbody></table>
<script type="text/javascript">

    CQ.Ext.onLoad(function() {

        document.getElementById("left-cell-content").style.display = "";

        // initialize DAM specific base params
        var qb = CQ.search.Util.getQueryBuilder();

        <%
                if (limit != null && limit.length() > 0) {
                    %>qb.setLimit("<%= limit %>");<%
                }

                %>qb.setPaths([<%
                for (int i = 0; i < paths.length; i++) {
                    String path = paths[i];
                    if (path.startsWith(".")) {
                        path = resource.getResourceResolver().getResource(currentPage.adaptTo(Resource.class),
                                                                          paths[i]).getPath();
                    }
                    %><%= i != 0 ? "," : "" %>"<%= path.replaceAll("\"", "\\\\\"") %>"<%
                }
                %>]);

                qb.setTypes([<%
                for (int i = 0; i < types.length; i++) {
                    %><%= i != 0 ? "," : "" %>"<%= types[i] %>"<%
                }
                %>]);

        qb.on("loadResult", function(result) {
            document.getElementById("results").innerHTML = result.total;
            document.getElementById("results-cell").style.visibility = "visible";

            if (qb.totalPages > 1) {
                document.getElementById("current-page").innerHTML = qb.currentPage;
                document.getElementById("total-pages").innerHTML = qb.totalPages;

                document.getElementById("backward").style.visibility = qb.currentPage == 1 ? "hidden" : "visible";
                document.getElementById("forward").style.visibility = qb.currentPage == qb.totalPages ? "hidden" : "visible";

                document.getElementById("paging-wrapper").style.display = "inline";
            }
            else {
                document.getElementById("paging-wrapper").style.display = "none";
            }
        });

        // add fulltext search field
        qb.addField({
            "xtype": "trigger",
            "name": "fulltext",
            "cls": "fulltextField",
            "renderTo": "fulltext-cell",
            "width": 281,
            "triggerClass": "x-form-search-trigger",
            "onTriggerClick": function() {
                CQ.search.Util.getQueryBuilder().submit();
            },
            "listeners": {
                "specialkey": function(field, e) {
                    if (e.getKey() == CQ.Ext.EventObject.ENTER) {
                        CQ.search.Util.getQueryBuilder().submit();
                    }
                }
            }
        });

        // param to not find sub assets
        qb.addHidden("mainasset", "true");

        // hit writer configuration
        qb.addHidden("p.hitwriter", "full");
        qb.addHidden("p.nodedepth", "4");

        qb.addHidden("orderby", "path");

        // enable RSS link in the header for cooliris support
        qb.setRssLinkUrl("/bin/querybuilder.feed");

        // initial submit
        CQ.search.Util.getQueryBuilder().submit();
    });
</script>
<link title="Media RSS (CQ5)" rel="alternate" type="application/atom+xml" href="<%= feedUrl %>?cookie=cq-mrss&p.limit=-1&path=%2Fcontent%2Fdam&type=dam:Asset&mainasset=true"/>
