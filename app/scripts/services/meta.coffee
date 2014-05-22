'use strict'

angular.module('laravelUiApp')
  .service 'Meta', ($resource, Cache) ->
    # AngularJS will instantiate a singleton by calling "new" on this function

    rtn =
      config:
        page:
          size: Cache.get 'config.page.size' || 15
      
      store: (url, paramDefaults, actions) ->
        $resource(url, paramDefaults, actions)

      cache: (url, paramDefaults, actions) ->
        $resource url, paramDefaults, {query: {method: 'get', isArray: true, cache: true}}

      flush: ->
        Cache.clear()