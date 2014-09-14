'use strict'

angular.module('laravelUiApp')
  .service 'Meta', ($resource, Cache) ->
    # AngularJS will instantiate a singleton by calling "new" on this function

    rtn =
      config:
        page:
          size: Cache.get 'config.page.size' || 15
      
      store: (url, paramDefaults, actions) ->
        $resource(url, paramDefaults, angular.extend {update: {method: 'put'}}, actions)

      cache: (url, paramDefaults, actions) ->
        $resource(url, paramDefaults, angular.extend {query: {method: 'get', isArray: true, cache: true}}, actions)

      flush: ->
        Cache.clear()

  .service '$meta', ($q, Meta, Cache) ->
    @mapping = 
      whlist: key: 'meta.list.warehouse', url: '/api/item/meta/warehouseList'
      userlist: key: 'meta.list.user', url: '/api/item/meta/userList'
      vendorlist: key: 'meta.list.vendor', url: '/api/purchase/vendor?select=id,name,code,abbreviation'
      itemlist: key: 'meta.list.item', url: '/api/item/meta/itemInfo?select=id,sku,description'
      platformlist: key: 'meta.list.platform', url: '/api/item/meta/platformList?select=id,name,abbreviation'
      translist: key: 'meta.list.trans', url: '/api/item/meta/transportList'
      taxlist: key: 'meta.list.tax', url: '/api/item/meta/taxList'

    @getKey = (key) ->
      @mapping[key]['key']

    @getUrl = (key) ->
      @mapping[key]['url']

    @fetch = (key) ->
      http = Meta.store(@getUrl key).query()
      http.$promise.then (rtn) =>
        Cache.set (@getKey key), rtn
      http

    # return $promise
    (key, refresh = false) =>
      if not refresh and rs = Cache.get(@getKey key)
        deferred = $q.defer()
        rs.$promise = deferred.promise
        deferred.promise.then (rs) ->
          rs 
        deferred.resolve rs
        rs
      else
        @fetch key
