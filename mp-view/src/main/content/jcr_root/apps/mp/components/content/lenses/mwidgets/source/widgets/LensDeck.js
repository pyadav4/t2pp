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
 * The <code>CQ.search.LensDeck</code> class provides a deck panel for lenses.
 * @class CQ.search.LensDeck
 * @extends CQ.search.LensContainer
 */
CQ.search.LensDeck = CQ.Ext.extend(CQ.search.LensContainer, {

    /**
     * @private
     */
    lastData: null,

    /**
     * @cfg {Mixed} renderButtonsTo
     * The default {@link CQ.Ext.Component#renderTo renderTo} property for the deck buttons.
     * If undefined the buttons are rendered to same element as the deck.
     */
    renderButtonsTo: null,

    /**
     * @cfg {Boolean} activateFirstLens
     * If true the first added lens will be activated.
     */

    /**
     * @private
     */
    lenses: [],

    /**
     * Creates a new <code>CQ.search.LensDeck</code> instance.
     * @constructor
     * @param {Object} config The config object
     */
    constructor: function(config) {

        config = CQ.Util.applyDefaults(config, {
            "renderButtonsTo": config.renderTo,
            "border": false,
            "activateFirstLens": true
        });

        CQ.search.LensDeck.superclass.constructor.call(this, config);
    },

    initComponent : function(){
        CQ.search.LensDeck.superclass.initComponent.call(this);

        this.addEvents(
            /**
             * @event switch
             * Fires when the active lens changes
             * @param {CQ.search.LensDeck} this
             * @param {CQ.search.Lens} oldLens the previously active lens (could be null)
             * @param {CQ.search.Lens} newLens the newly active lens (could be null)
             */
            'switch'
        );
    },

    getCurrentLens: function() {
        return this.activeItem;
    },

    loadData: function(data) {
        this.lastData = data;
        this.activeItem.loadData(data);
        this.doLayout();
        this.activeItem.doLayout();
    },

    getSelection: function() {
        return this.activeItem.getSelection();
    },

    // managing lenses

    /**
     * Adds a new {@link CQ.search.Lens} to this deck. A button to activate
     * the lens will be added to the button bar of the deck.
     * @param {CQ.search.Lens} widget The lens to add
     * @param {String} name The name of the lens. Will also be used for the
     *        {@link CQ.Ext.Button#iconCls iconCls} of the button.
     * @param {Object} buttonConfig The config object of the button
     */
    add: function(widget, name, buttonConfig) {
        try {
            var deck = this;
            buttonConfig = CQ.Util.applyDefaults(buttonConfig, {
                "toggleGroup": "cq-lensdeck", //todo: id
                "enableToggle": true,
                "allowDepress": false,
                "iconCls": name ? name : "",
                "renderTo": widget.renderButtonTo ? widget.renderButtonTo : this.renderButtonsTo,
                "text": widget.buttonText ? widget.buttonText : "",
                "tabTip": widget.text ? widget.text : "",
                "pressed": this.lenses.length == 0, //first lens
                "listeners": {
                    "click": function() {
                        deck.setActiveItem(widget.id);
                        if (deck.lastData && deck.activeItem.loadLastData) {
                            deck.activeItem.loadData(deck.lastData);
                        }
                    }
                }
            });
            var b = new CQ.Ext.Button(buttonConfig);
            widget.lensName = name;
            widget.button = b;
            // default value
            if (typeof widget.loadLastData === "undefined") {
                widget.loadLastData = true;
            }
            CQ.search.LensDeck.superclass.add.call(this, widget);
            this.lenses.push(widget);
        }
        catch (e) {
            //console.log(e.message);
        }

        if (this.activateFirstLens && this.lenses.length == 1) {
            this.setActiveItem(widget.id);
        }
    },

    /**
     * Activates the lens of the given ID. Fires the 'switch' event.
     * @param {String} id The id of the lens to activate
     * @return {Object} The activated lens
     */
    setActiveItem: function(id) {
        var oldLens = this.activeItem;

        for (var i = 0; i < this.lenses.length; i++) {
            if (this.lenses[i].id == id) {
                this.activeItem = this.lenses[i];
                this.activeItem.show();
            }
            else {
                this.lenses[i].hide();
            }
        }

        this.fireSwitch(oldLens, this.activeItem);

        return this.activeItem;
    },

    /**
     * Activates the lens of the given name as set in {@link #add}. Fires the 'switch' event.
     * @param {String} name The name of the lens to activate
     * @return {CQ.search} The activated lens
     */
    setActiveLens: function(name) {
        var oldLens = this.activeItem;

        for (var i = 0; i < this.lenses.length; i++) {
            if (this.lenses[i].lensName == name) {
                // unselect the button for the previously active lens
                if (this.activeItem) {
                    this.activeItem.button.toggle(false);
                }
                this.activeItem = this.lenses[i];
                // select the button for the now active lens
                this.activeItem.button.toggle(true);
                this.activeItem.show();
            }
            else {
                this.lenses[i].hide();
            }
        }

        this.fireSwitch(oldLens, this.activeItem);

        return this.activeItem;
    },

    // private stuff

    /**
     * @private
     */
    fireSwitch: function(oldLens, newLens) {
        this.fireEvent('switch', this, oldLens, newLens);
    }


});


CQ.Ext.reg("lensdeck", CQ.search.LensDeck);
