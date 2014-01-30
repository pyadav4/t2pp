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
 * The <code>CQ.search.Lens</code> class provides an abstract lens.
 * @class CQ.search.Lens
 * @extends CQ.Ext.Panel
 * @constructor
 * @param {Object} config The config object
 */
CQ.search.Lens = CQ.Ext.extend(CQ.Ext.Panel, {

    /**
     * @cfg {String} text
     * The text of the lens as used in certain {@link LensContainer containers}
     * e.g. for the button of a {@link LensDeck#tabTip}
     * @private
     */
    // (tabTip seems not to work for LensDeck)
    text: "",

    constructor: function(config) {
        CQ.search.Lens.superclass.constructor.call(this, config);
    },

    /**
     * Loads the given data
     * @param {Object} data
     */
    loadData: function(data) {
    },

    /**
     * Returns the selected items
     * @return {Array} The selected items
     */
    getSelection: function() {
    }

});

CQ.Ext.reg("lens", CQ.search.Lens);
