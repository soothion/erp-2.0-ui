'use strict'

angular.module('laravelUiApp')
  .filter 'warehouse', ($filter, $meta) ->
    warehouses = $meta('whlist')
    (id) ->
      ($filter('filter') warehouses, {id: id})[0]?.name || id
