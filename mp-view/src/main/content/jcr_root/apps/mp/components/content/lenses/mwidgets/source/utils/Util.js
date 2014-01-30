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
 * The <code>CQ.search.Util</code> contains utilities for a globally set
 * {@link CQ.search.QueryBuilder Query Builder} and {@link CQ.search.Lens lenses}.
 * @static
 * @class CQ.search.Util
 */
CQ.search.Util = function() {

    /**
     * The global {@link CQ.search.QueryBuilder Query Builder}.
     * @type CQ.search.QueryBuilder
     */
    var queryBuilder = null;

    /**
     * An optional container to hold multiple lenses (e.g. a {@link CQ.search.LensDeck lens deck}).
     * @type CQ.search.LensContainer
     */
    var lensContainer = null;

    /**
     * The unique lens or the active lens of {@link #lensContainer}.
     * @type CQ.search.Lens
     */
    var lens = null;

    /**
     * The action to execute on double click on a result.
     * @type Function
     */
    var dblClickAction = function(){};

    return {
        /**
         * Sets the Query Builder.
         * @param {CQ.search.QueryBuilder} qBuilder The Query Builder
         */
        setQueryBuilder: function(qBuilder) {
            queryBuilder = qBuilder;
        },

        /**
         * Returns the Query Builder.
         * @return {CQ.search.QueryBuilder} The Query Builder
         */
        getQueryBuilder: function() {
            return queryBuilder;
        },

        /**
         * Sets the lens container.
         * @param {CQ.search.LensContainer} container The lens container
         */
        setLensContainer: function(container) {
            lensContainer = container;
        },

        /**
         * Returns the lens container or <code>null</code> if no container is set.
         * @return {CQ.search.LensContainer} The lens container
         */
        getLensContainer: function() {
            return lensContainer;
        },

        /**
         * Returns the active lens of the lens container or the solely lens.
         * @return {CQ.search.LensContainer/CQ.search.Lens}
         */
        getLens: function() {
            if (lensContainer) {
                return lensContainer.getCurrentLens();
            }
            else {
                return lens;
            }
        },

        /**
         * Adds a lens to the lens container or - if no container is defined -
         * sets the solely lens.
         * @param {CQ.search.Lens} le The lens
         * @param {String} name The name of the lens (optional for a solely lens but required for lens containers)
         * @param {Object} buttonConfig The config object of the button (optional for a solely lens but required for lens containers)
         */
        addLens: function(le, name, buttonConfig) {
            if (lensContainer) {
                lensContainer.add(le, name, buttonConfig);
            }
            else {
                lens = le;
            }
        },

        /**
         * Passes the given data to the lens container or - if no
         * containter is defined - to the solely lens.
         * @param {Object} data
         */
        loadData: function(data) {
            if (lensContainer) {
                lensContainer.loadData(data);
            }
            else if (lens) {
                lens.loadData(data);
                lens.doLayout();
            }
        },

        /**
         * Returns the selection of the active lens.
         * @return {Object/Array} The selected items (typically a CQ.Ext.data.Record)
         */
        getSelection: function() {
            return this.getLens().getSelection();
        },

        /**
         * Returns the paths of the selected items
         * @return {Array} The selected paths
         */
        getSelectedPaths: function() {
            var s = this.getSelection();
            var paths = [];
            for (var i = 0; i < s.length; i++) {
                paths.push(s[i]["jcr:path"]);
            }
            return paths;
        },


        setDblClickAction: function(func) {
            dblClickAction = func;
        },

        resultDblClick: function() {
            if (dblClickAction) {
                dblClickAction(arguments);
            }
        }

    };

}();