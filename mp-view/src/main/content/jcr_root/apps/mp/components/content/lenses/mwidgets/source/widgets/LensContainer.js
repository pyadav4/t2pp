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
 * The <code>CQ.search.LensContainer</code> class provides an abstract container
 * for lenses.
 * @class CQ.search.LensContainer
 * @extends CQ.Ext.Panel
 */
//todo: extend CQ.search.Lens?
CQ.search.LensContainer = CQ.Ext.extend(CQ.Ext.Panel, {

    /**
     * @constructor
     * @param {Object} config The config object
     */
    constructor: function(config) {
        CQ.search.LensContainer.superclass.constructor.call(this, config);
    },

    /**
     * Loads the given data into the active lens.
     * @param {Object} data
     */
    loadData: function(data) {
    },

    /**
     * Returns the selected items of the active lens.
     * @return {Object/Array} The selected items (typically a CQ.Ext.data.Record)
     */
    getSelection: function() {
    },

    /**
     * Returns the active lens.
     * @return {CQ.search.Lens} The active lens
     */
    getCurrentLens: function() {
    }

});

