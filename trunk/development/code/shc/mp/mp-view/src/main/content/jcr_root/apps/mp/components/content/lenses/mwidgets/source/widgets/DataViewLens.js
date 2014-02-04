function getShadowboxPopup(resourcePath){
	var extension = resourcePath.split('.').pop().toLowerCase();
//	console.log(extension);
	if(extension=="png"||extension=="jpeg"||extension=="jpg"){
		Shadowbox.open({content:resourcePath,player:'img'});
	}
    else if(extension=="swf"||extension=="mp4"||extension=="ogg" || extension=="pdf"  || extension=="doc"  || extension=="docx"){
        Shadowbox.open({content:resourcePath,player:'iframe', height:480, width:640});
	}
}

CQ.search.DataViewLens = CQ.Ext.extend(CQ.search.Lens, {


    /**
     * @cfg {Object} storeConfig
     * The config object for the {@link CQ.Ext.DataView#store store} of the data view.
     */
    storeConfig: null,


    initComponent: function() {
        CQ.search.DataViewLens.superclass.initComponent.call(this);

        try {
            this.dataView = this.findByType("dataview")[0];
        }
        catch (e) {}
    },


    /**
     * Creates a new <code>CQ.search.DataViewLens</code> instance.
     * @constructor
     * @param {Object} config The config object
     */
    constructor: function(config) {

        if (!config.store) {
            // use default store

            var storeConfig = CQ.Util.applyDefaults(config.storeConfig, {
                "reader": new CQ.Ext.data.JsonReader({
                    "totalProperty": "results",
                    "root": "hits",
                    "fields": [
                        "jcr:path", "jcr:content", "jcr:created"
                    ],
                    "id": "path"
                }),
                "baseParams": {
                    "_charset_": "utf-8"
                },
                "listeners": {
                    "load": function(store, records, options) {
                        store.records = records;
                    }
                }
            });
        }

// todo: move mosaic/dam specific config to mosaic lens resp. DamDataViewLens
        config = CQ.Util.applyDefaults(config, {
            "autoScroll": true,
            "border": false,
            "items": {
                "xtype": "dataview",
                "cls": "cq-cft-dataview",
                "loadingText": CQ.I18n.getMessage("Loading content..."),
                "multiSelect": true,
                "singleSelect": true,
                "overClass": "x-view-over",
                "emptyText": CQ.I18n.getMessage("No assets available"),
                "autoHeight": true,
                "tpl":
                	'<ul class="gallery grid">' +
                    '<tpl for=".">' +
                    	'<li onclick="getShadowboxPopup(\'{[CQ.HTTP.externalize(values.path,true)]}\');">' +
                    		'<a class="group" ><img  src="{[CQ.HTTP.externalize(values.path,true)]}.thumb.100.140{[values.ck ? "." + values.ck : ""]}.png" alt="" ></a>' +
                    		'<h2>{[CQ.shared.XSS.getXSSValue(values.shortTitle)]}</h2>' +
                    	'</li>'+
                    '</tpl>' +
                    '</ul>' + 
                    '<div class="x-clear"></div>',
                "itemSelector": ".item",
                "store": new CQ.Ext.data.GroupingStore(storeConfig),
                "prepareData": function(data) {
                    var meta = data["jcr:content"]["metadata"];
                    data.meta = meta;
                    data.name = "";
                    data.title = "";
                    data.shortTitle = "";
                    data.shortPath = "";

                    try {
                        var mod = data["jcr:content"]["renditions"]["cq5dam.thumbnail.48.48.png"]["jcr:content"]["jcr:lastModified"];
                        data.ck = new Date(mod).getTime();
                    }
                    catch(e) {}
                    data.id = this.id;

                    data.path = data["jcr:path"];
                    try {
                        data.name = data.path.substring(data.path.lastIndexOf("/") + 1);
                        data.shortPath = data.path.substring(0, data.path.lastIndexOf("/") + 1);
                        var ellipsis = "";
                        while (data.shortPath.length > 28) {
                            if (data.shortPath.indexOf("/") == data.shortPath.lastIndexOf("/")) break;
                            data.shortPath = data.shortPath.substring(data.shortPath.indexOf("/") + 1);
                            ellipsis = ".../";
                        }
                        data.shortPath = ellipsis + data.shortPath;

                        if (meta && meta["dc:title"]) {
                            var t = meta["dc:title"];
                            if (t instanceof Array) data.title = t[0];
                            else data.title = t;
                        }
                        //the array above for title might have an empty string at 0th index
                        if (!data.title) {
                            data.title = data.name;
                        }
                        data.shortTitle = CQ.Ext.util.Format.ellipsis(data.title, 25);
                    }
                    catch (e) {}

                    data.path = CQ.HTTP.encodePath(data.path);

                    try {
                        // encode values for HTML output in JS
                        data.name = data.name.replace(/"/g, "&quot;").replace(/'/g,"&#39");
                        data.title = data.title.replace(/"/g, "&quot;").replace(/'/g,"&#39");
                        data.shortTitle = data.shortTitle.replace(/"/g, "&quot;").replace(/'/g,"&#39");
                        data.shortPath = data.shortPath.replace(/"/g, "&quot;").replace(/'/g,"&#39");
                    }
                    catch (e) {}

                    try {
                        var md = meta ? meta["dam:ModificationDate"] : undefined ;
                        var mdParsed = null;
                        if (md) {
                            mdParsed = new Date(md);
                            if (isNaN(mdParsed)) {
                                mdParsed = Date.parseDate(md, "c");
                            }
                        }
                        if (mdParsed && !isNaN(mdParsed)) data.modificationDate = mdParsed;
                    }
                    catch (e) {}

                    try {
                        var cd = meta ? meta["dam:CreationDate"] : undefined;
                        var cdParsed = null;
                        if (cd) {
                            cdParsed = new Date(cd);
                            if (isNaN(cdParsed)) {
                                cdParsed = Date.parseDate(data.creationDate, "c");
                            }
                        }
                        else {
                            cdParsed = new Date(data["jcr:created"]);
                        }
                        if (cdParsed && !isNaN(cdParsed)) data.creationDate = cdParsed;
                    }
                    catch (e) {}

                    data.imageDimensions = "";
                    if (meta && meta["tiff:ImageWidth"] && meta["tiff:ImageLength"]) {
                        data.imageDimensions = meta["tiff:ImageWidth"] + " &times; " + meta["tiff:ImageLength"];
                    }

                    return data;
                }
//                "listeners": {
//                    "dblclick": function() {
//                        CQ.search.Util.assetDblClick();
//                    }
//                }
            }
        });

        CQ.search.DataViewLens.superclass.constructor.call(this, config);
    },

    loadData: function(data) {
        if (this.dataView) {
            this.dataView.store.loadData(data);
        }
    },

    getSelection: function() {
        try {
            var r = this.dataView.getSelectedRecords();
            var s = [];
            for (var i = 0; i < r.length; i++) {
                s.push(r[i].json);
            }
            return s;
        }
        catch (e) {
            return [];
        }
    }

});


CQ.Ext.reg("mpdataviewlens", CQ.search.DataViewLens);
