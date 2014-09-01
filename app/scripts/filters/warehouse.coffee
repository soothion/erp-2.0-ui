'use strict'

angular.module('laravelUiApp')
  .filter 'warehouse', ($filter, $meta) ->
    warehouses = null
    serviceInvoked = false

    realFilter = (id) ->
      ($filter('filter') warehouses, {id: parseInt id}, true)[0]?.name || id

    (id) ->
      if not warehouses? and not serviceInvoked
        serviceInvoked = true
        warehouses = $meta('whlist')
        '-'
      else
        realFilter id
