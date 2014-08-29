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
    whlist: Cache.get 'meta.whlist' or Meta.cache('/api/item/meta/warehouseList').query (rtn) ->
      Cache.set 'meta.whlist', rtn
