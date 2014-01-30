<%--
  Mosaic Lens component

--%><%@ page import="java.util.Calendar" %><%
%><%@include file="/libs/foundation/global.jsp"%><%

    String name = properties.get("name", "Mosaic");
    Long time = Calendar.getInstance().getTimeInMillis();

%>



<div id="lens-mosaic-button-wrapper-<%= time %>" class="lens-button-wrapper"></div><!--
--><script type="text/javascript">
    CQ.Ext.onLoad(function() {
        var config = {
            //"xtype": "dataviewlens",
            "xtype": "mpdataviewlens",
            "style": "overflow:visible;",
            "renderButtonTo": "lens-mosaic-button-wrapper-<%= time %>",
            "proxyConfig": {
                "url": "/bin/wcm/contentfinder/view.json/content/dam"
            },
            "storeConfig": {
                "baseParams": {
                    "mimeType": "image"
                }
            },
            "items": {
                "cls": "lens-dataview mosaic"
            },
            "listeners": {
                "afterlayout": function() {
                    // workaround to set overflow visible
                    var el = this.body || this.el;
                    if(el && !CQ.Ext.isIE){
                        el.setOverflow('visible');
                    }
                }
            }
        };
        var lens = CQ.Util.build(config);
        CQ.search.Util.addLens(lens, "mosaic");

    });
</script>
