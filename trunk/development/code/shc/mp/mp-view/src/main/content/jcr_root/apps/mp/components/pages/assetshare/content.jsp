
<%@include file="/libs/foundation/global.jsp" %>
<div class="container_16">
    <div class="grid_16 body_container">
        <div class="querybuilder-wrapper">
            <cq:include path="querybuilder" resourceType="mp/components/content/assetshare/querybuilder" />
        </div>
    </div>
    <div class="clear"></div>
</div>

<script type="text/javascript" src="/apps/mp/components/content/lenses/mwidgets/source/shadowbox/shadowbox.js"></script>

<script type="text/javascript">
	/*CQ.Ext.onReady(function(){
        Shadowbox.init();
	});*/

	function popUpBox() { 
		//alert("popUpBox");
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
	    overlayOpacity: 0.5
	}, popUpBox);
</script> 