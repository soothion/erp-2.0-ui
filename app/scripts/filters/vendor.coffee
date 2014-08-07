'use strict'

angular.module('laravelUiApp')
  .filter 'vendor', (Meta) ->
    vendors = Meta.cache('/api/purchase/vendor/select/id,name,code').query()
    (id) ->
      angular.forEach vendors, (value, key) ->
        if value.id is id
          id = value.name
      id
          
