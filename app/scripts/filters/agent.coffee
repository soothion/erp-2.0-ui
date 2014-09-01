'use strict'

angular.module('laravelUiApp')
  .filter 'agent', ($filter, $meta) ->
    userlist = null
    serviceInvoked = false

    realFilter = (id) ->
      ($filter('filter') userlist, {id: parseInt id}, true)[0]?.name || id

    (id) ->
      if not userlist? and not serviceInvoked
        serviceInvoked = true
        userlist = $meta('userlist')
        '-'
      else
        realFilter id