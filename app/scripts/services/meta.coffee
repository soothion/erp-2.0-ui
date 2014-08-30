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

  .service '$meta', (Meta, Cache) ->
    @mapping = 
      whlist: key: 'meta.list.warehouse', url: '/api/item/meta/warehouseList'
      userlist: key: 'meta.list.user', url: '/api/item/meta/warehouseList'

    @getKey = (key) ->
      @mapping[key]['key']

    @getUrl = (key) ->
      @mapping[key]['url']

    (key) =>
      rs = (Cache.get @getKey key) or http = Meta.cache(@getUrl key).query()
      if http?
        http.$promise.then (rtn) =>
          Cache.set (@getKey key), rtn
      rs
