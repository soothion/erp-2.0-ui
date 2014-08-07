'use strict'

angular.module('laravelUiApp')
  .filter 'warehouse', (Meta) ->
    (id) ->
      Meta.cache('/api/item/meta/warehouseList').query (rtn) ->
        angular.forEach rtn, (value, key) ->
          if value.id == id
            value.name
