/*
 * Copyright 1997-2009 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */

/**
 * The <code>CQ.search.IFrameLens</code> class provides a lens that uses an
 * iFrame.
 * @class CQ.search.IFrameLens
 * @extends CQ.search.Lens
 * @private (not documented, currently no working sample exists)
 */
CQ.search.IFrameLens = CQ.Ext.extend(CQ.search.Lens, {


    /**
     * @cfg {Object} storeConfig
     */
    // private
    storeConfig: null,


    iframe: null,

    /**
     * Creates a new <code>CQ.search.IFrameLens</code> instance.
     *
     * Example:
     * <pre><code>
    //todo
});
       </pre></code>
     * @constructor
     * @param {Object} config The config object
     */
    constructor: function(config) {
        var id = config.id ? config.id : CQ.Util.createId();
        config = CQ.Util.applyDefaults(config, {
            "renderTo": CQ.Util.ROOT_ID,
            "id": id,
            "html": '<iframe src="' + (config.url ? config.url : CQ.Ext.SSL_SECURE_URL) + '"' +
                    ' id="' + id + '_iframe" ' +
                    ' style="width:100%;height:100%;overflow:auto;border:none;' +
                    ' border="0" frameborder="0"></iframe>'
        });

        CQ.search.IFrameLens.superclass.constructor.call(this, config);
    },

    getIFrame: function() {
        if (!this.iframe) {
            this.iframe = document.getElementById(this.id + "_iframe");
        }
        return this.iframe;
    },

    loadData: function(data) {
        var f = this.getIFrame();
        var url = this.url;
        for (var i = 0; i < data.hits.length; i++) {
            url = CQ.utils.HTTP.addParameter(url, "path", data.hits[i].path);
        }
        f.src = url;
    },

    getSelection: function() {
        var f = this.getIFrame();
        try {
            return f.contentWindow.getSelection();
        }
        catch (e) {
            return [];
        }
    }

});


CQ.Ext.reg("iframelens", CQ.search.IFrameLens);
