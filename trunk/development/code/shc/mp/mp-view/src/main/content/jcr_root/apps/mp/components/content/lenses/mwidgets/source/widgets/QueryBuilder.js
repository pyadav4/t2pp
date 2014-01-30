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
 * The <code>CQ.search.QueryBuilder</code> class provides a form panel to build
 * search queries.
 * <pre><code>
var qb = new CQ.search.QueryBuilder({
    "form": new CQ.Ext.form.BasicForm("qb-form", {
        "method": "GET",
        "url": "/bin/querybuilder.json"
    },
    "renderFieldsTo": "qb-form"
});
qb.setTypes(["dam:Asset"]);
qb.setPath(["/content/dam/geometrixx/travel", "/content/dam/geometrixx/documents"]);

CQ.search.Util.setQueryBuilder(qb);
   </pre></code>

 Use {@link CQ.search.Util#setQueryBuilder} in order to easily access the Query Builder
 at other places using {@link CQ.search.Util#getQueryBuilder} to e.g. submit it.

 * @class CQ.search.QueryBuilder
 * @extends CQ.Ext.Panel
 */
CQ.search.QueryBuilder = CQ.Ext.extend(CQ.Ext.Panel, {

    /**
     * @cfg {CQ.Ext.form.BasicForm} form
     * The form of the Query Builder.
     */

	/**
	 * @cfg {String} renderFieldsTo
     * The ID of the HTML element where fields will be added to (when using {@link #addField}).
	 */
	renderFieldsTo: null,

    // todo: limit etc as config options
    offset: 0,

    limit: 5,

    // the fields of the base paths
    pathFields: [],

    pathPredicateName: "path",

    /**
     * @cfg {String} rssLinkUrl
     * The URL for an RSS feed. If it is set every submit will update the
     * according link in the header of the top most document.
     */
    rssLinkUrl: "",

    /**
     * Counters to generate unique predicate and group IDs.
     * @private
     * @type Number
     */
    idCounter: 0,

    /**
     * Charset for the form POST.
     * @private
     */
    charset: "utf-8",

    /**
     * Creates a new <code>CQ.search.QueryBuilder</code> instance.
     * @constructor
     * @param {Mixed} el The form element or its id
     * @param {Object} config Configuration options
     */
    constructor: function(config) {
		this.renderFieldsTo = config.renderFieldsTo;
//        CQ.search.Util.setQueryBuilder(this);
        CQ.search.QueryBuilder.superclass.constructor.call(this, config);

        // add events
        this.addEvents(
            /**
             * @event loadResult
             * Fires after search results have been loaded.
             */
            'loadResult',

            /**
             * @event loadError
             * Fires if loading the results fails.
             */
            'loadError'
        );
    },

    /**
     * Adds a hidden field to the form.
     * @param {String} name The name of the hidden field
     * @param {String} value The value of hidden field
     * @return {CQ.Ext.form.Hidden} The created hidden field.
     */
	addHidden: function(name, value) {
		if (!this.form) {
			return null;
		}
        var hidden = new CQ.Ext.form.Hidden({
            "renderTo": this.form.el.dom,
            "name": name,
            "value": value
        });
        this.form.add(hidden);
        return hidden;
	},

    /**
     * Sets the value of a hidden field. If no field of the specified
     * name exists it will be created.
     * @param {String} name The name of the hidden field
     * @param {String} value The value of hidden field
     * @return {CQ.Ext.form.Hidden} The created hidden field
     */
	setHidden: function(name, value) {
        if (!this.form) {
            return null;
        }
		var field = this.form.findField(name);
		if (field) {
			field.setValue(value);
            return field;
		} else {
			return this.addHidden(name, value);
		}
	},

    // @deprecated
    // no usages in CQ 5.4 code base
    addToHiddenGroup: function(groupName, value) {
        var groupId = this.createGroupId() + "." + groupName;
        this.setHidden(groupId, value);
        return groupId;
    },

    /**
     * Adds a field to the form.
     * @param {Object} config The config of the field
     * @return {CQ.Ext.form.Field} The created field
     */
	addField: function(config) {
        if (!this.form || !config) {
            return null;
        }
		if (!config.renderTo) {
			config.renderTo = this.renderFieldsTo;
		}
        var field = CQ.Util.build(config);
		this.form.add(field);
        return field;
	},
	
	/**
     * Removes the field from the form.
     * @param {CQ.Ext.form.Field} field The field to be removed.
     * No-op if field is not present.
     */
	removeField: function(field) {
		if (field.el) {
			field.el.remove();
        }
		this.form.remove(field);
	},

    /**
     * Sets the options to restrain the search to certain paths. If a {@link #setPathPredicateName path predicate}
     * is set the paths set by <code>setPaths</code> are ignored.
     * @param {String[]} paths The paths
     */
    setPaths: function(paths) {
        this.pathfields = [];
        //todo: remove existing paths?
        var groupId = this.createGroupId();
        for (var i = 0; i < paths.length; i++) {
            this.pathFields.push(this.setHidden(groupId + "." + i + "_path", paths[i]));
        }
        if (paths.length > 1) {
            this.setHidden(groupId + ".p.or", "true");
        }
    },

    /**
     * Sets the options to restrain the search to certain node types.
     * @param {String[]} types The node types
     */
    setTypes: function(types, /* optional */ groupId) {
        if (!groupId) {
            groupId = this.createGroupId();
        }
        for (var i = 0; i < types.length; i++) {
            this.setHidden(groupId + "." + i + "_type", types[i]);
        }
        if (types.length > 1) {
            this.setHidden(groupId + ".p.or", "true");
        }
    },

    // @deprecated
    // no usages in CQ 5.4 code base
    replaceTypes: function(types) {
        var groupId = null;
        var fields = this.form.items;
        fields.each(function(field) {
                var name = field.getName();
                var nameLen = name.length;
                if ((nameLen > 5) && (name.substring(nameLen - 5, nameLen) == "_type")) {
                    var groupSep = name.indexOf(".");
                    groupId = name.substring(0, groupSep);
                    return false;
                }
                return true;
            }, this);
        if (groupId != null) {
            var fieldsToRemove = [ ];
            fields.each(function(field) {
                    var name = field.getName();
                    var groupSep = name.indexOf(".");
                    if (groupSep > 0) {
                        if (name.substring(0, groupSep) == groupId) {
                            fieldsToRemove.push(field);
                        }
                    }
                    return true;
                }, this);
            for (var r = 0; r < fieldsToRemove.length; r++) {
                var fieldToRemove = fieldsToRemove[r];
                if (fieldToRemove.el) {
                    fieldToRemove.el.remove();
                }
                this.form.remove(fieldToRemove);
            }
        }
        this.setTypes(types, groupId);
    },

    /**
     * Sets the name of the path predicate. If it is set and the value of the according
     * form field is not empty this value will be used to restrain the search. Otherwise
     * the paths set in {@link #setPaths} restrain the search.
     *
     * @param {String} name
     */
    setPathPredicateName: function(name) {
        this.pathPredicateName = name;
    },

    /**
     * Creates a unique ID for a predicate group.
     * @return {String} The unique ID
     */
    createGroupId: function() {
        return this.createId("group");
    },

    /**
     * Creates a unique ID for a predicate.
     * @param {String} name The name (optional)
     * @return {String} The unique ID
     */
    createId: function(name) {
        if (!name) name = "predicate";
        return this.idCounter++ + "_" + name;
    },

    /**
     * Sets the limit of results to return. The limit corresponds to the results
     * per page.
     * @param {Number} limit
     */
    setLimit: function(limit) {
        this.limit = parseInt(limit);
        this.setHidden("p.limit", this.limit);
    },

    /**
     * Browses in the results one page forward.
     */
    nextPage: function() {
        this.page(1);
    },

    /**
     * Browses in the results one page back.
     */
    lastPage: function() {
        this.page(-1);
    },

    // private
    page: function(delta) {
        var offset = this.limit * delta + this.offset;
        this.submit(offset);
    },

    /**
     * Sets the {@link #rssLinkUrl}.
     * @param {String} url The URL
     */
    setRssLinkUrl: function(url) {
        this.rssLinkUrl = url;
    },

    /**
     * Set the charset of the request.
     * @param {String} charset
     */
    setCharset: function(charset) {
        this.charset = charset;
    },

    /**
     * Build and submits the query.
     * @param {Number} offset The offset of the first result item related to all results (allows paging)
     */
    submit: function(offset) {
        if (!this.form) {
            return;
        }

        this.offset = offset ? offset : 0;
        this.setHidden("p.offset", this.offset);

        if (this.pathFields.length > 0) {
            // check if there is a path predicate with a value set. if yes, disable
            // the base paths
            var p = this.form.findField(this.pathPredicateName);
            if (p) {
                var doEnable = p.getValue() == "";
                for (var i = 0; i < this.pathFields.length; i++) {
//                    if (doEnable) this.pathFields[i].getEl().dom.removeAttribute("disabled");
//                    else this.pathFields[i].getEl().dom.setAttribute("disabled", "disabled");
                    if (doEnable) this.pathFields[i].enable();
                    else this.pathFields[i].disable();
                }
            }
        }

		var qb = this;
        var config = {
            "params": {
                "_charset_": this.charset
            },
            "success": function(form, action) {
                try {
                    CQ.search.Util.loadData(action.result);
                    qb.currentPage = Math.floor(action.result.offset / qb.limit) + 1;
                    qb.totalPages = Math.ceil(action.result.total / qb.limit);
                    qb.fireEvent("loadResult", action.result, qb);
                }
                catch (e) {
                    qb.fireEvent("loadError", qb);
                }
            },
            "failure": function() {
                qb.fireEvent("loadError", qb);
            }
        };
        var action = new CQ.Ext.form.Action.Submit(this.form, config);
        this.form.doAction(action);

        if (qb.rssLinkUrl) {
            var values = this.form.getValues();
            var cookieValue = "p.limit=-1";
            for (var name in values) {
                if (values[name] === "" || name == "p.limit" || name == "p.offset") {
                    // atom feed: avoid empty values in cookie; limit is hardcoded "-1"; avoid offset
                    continue;
                }
                cookieValue += "&" + encodeURIComponent(name) + "=" + encodeURIComponent(values[name]);
            }
            CQ.HTTP.setCookie("cq-mrss", cookieValue, "/bin");
        }
    }

});


CQ.Ext.reg("querybuilder", CQ.search.QueryBuilder);
