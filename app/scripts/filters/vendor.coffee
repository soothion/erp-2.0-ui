'use strict'

angular.module('laravelUiApp')
  .filter 'vendor', ($filter, $meta) ->
    vendors = null
    serviceInvoked = false

    realFilter = (id) ->
      ($filter('filter') vendors, {id: parseInt id}, true)[0]?.name || id

    (id) ->
      if not vendors? and not serviceInvoked
        serviceInvoked = true
        vendors = $meta('vendorlist')
        '-'
      else
        realFilter id
