'use strict'

angular.module('laravelUiApp')
  .filter 'platform', ($filter, $meta) ->
    platforms = null
    serviceInvoked = false

    realFilter = (id) ->
      ($filter('filter') platforms, {id: parseInt id}, true)[0]?.abbreviation || id

    (id) ->
      if not platforms? and not serviceInvoked
        serviceInvoked = true
        platforms = $meta('platformlist')
        '-'
      else
        realFilter id
