'use strict'

angular.module('laravelUiApp')
  .filter 'warehouse', (Meta) ->
    warehouses = Meta.cache('/api/item/meta/warehouseList').query()
    (id) ->
      angular.forEach warehouses, (value, key) ->
        if value.id == id
          id = value.name
      id