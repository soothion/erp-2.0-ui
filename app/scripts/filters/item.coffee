'use strict'

angular.module('laravelUiApp')
  .filter 'item', ($filter, $meta) ->
    items = null
    serviceInvoked = false

    realFilter = (id) ->
      ($filter('filter') items, {id: parseInt id}, true)[0]?.sku|| id

    (id) ->
      if not items? and not serviceInvoked
        serviceInvoked = true
        items = $meta('itemlist')
        '-'
      else
        realFilter id
