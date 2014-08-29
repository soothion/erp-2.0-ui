'use strict'

angular.module('laravelUiApp')
  .filter 'warehouse', ($meta) ->
    (id) ->
      angular.forEach $meta.whlist, (value, key) ->
        if value.id == id
          id = value.name
      id