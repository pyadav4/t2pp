/**
 * A DataFeed with a static set of stores. Provides sorting of stores by
 * proximity and feature filtering (store must have <em>all</em> features from
 * the filter).
 * @example <pre>
 * var dataFeed = new storeLocator.StaticDataFeed();
 * jQuery.getJSON('stores.json', function(json) {
 *   var stores = parseStores(json);
 *   dataFeed.setStores(stores);
 * });
 * new storeLocator.View(map, dataFeed);
 * </pre>
 * @implements {storeLocator.DataFeed}
 * @constructor
 * @implements storeLocator_StaticDataFeed
 */
storeLocator.StaticDataFeed = function() {
  /**
   * The static list of stores.
   * @private
   * @type {Array.<storeLocator.Store>}
   */
  this.stores_ = [];
};
storeLocator['StaticDataFeed'] = storeLocator.StaticDataFeed;

/**
 * This will contain a callback to be called if getStores was called before
 * setStores (i.e. if the map is waiting for data from the data source).
 * @private
 * @type {Function}
 */
storeLocator.StaticDataFeed.prototype.firstCallback_;

/**
 * Set the stores for this data feed.
 * @param {!Array.<!storeLocator.Store>} stores  the stores for this data feed.
 */
storeLocator.StaticDataFeed.prototype.setStores = function(stores) {
  this.stores_ = stores;
  if (this.firstCallback_) {
    this.firstCallback_();
  } else {
    delete this.firstCallback_;
  }
};

/**
 * @inheritDoc
 */
storeLocator.StaticDataFeed.prototype.getStores = function(bounds, features,
    callback) {

  // Prevent race condition - if getStores is called before stores are loaded.
  if (!this.stores_.length) {
    var that = this;
    this.firstCallback_ = function() {
      that.getStores(bounds, features, callback);
    };
    return;
  }

  // Filter stores for features.
  var stores = [];
  for (var i = 0, store; store = this.stores_[i]; i++) {
    if (store.hasAllFeatures(features)) {
      stores.push(store);
    }
  }
	stores=[];
	
  for (var i = 0, store; store = this.stores_[i]; i++) {
      
    if (store.distanceTo(map.getCenter())<radius*1.60934 ) {

      stores.push(store);
    }
  }  
  this.sortByDistance_(map.getCenter(), stores);
  callback(stores);
};

/**
 * Sorts a list of given stores by distance from a point in ascending order.
 * Directly manipulates the given array (has side effects).
 * @private
 * @param {google.maps.LatLng} latLng the point to sort from.
 * @param {!Array.<!storeLocator.Store>} stores  the stores to sort.
 */
storeLocator.StaticDataFeed.prototype.sortByDistance_ = function(latLng,
    stores) {
  stores.sort(function(a, b) {
    return a.distanceTo(latLng) - b.distanceTo(latLng);
  });
};
