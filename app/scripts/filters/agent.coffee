'use strict'

angular.module('laravelUiApp')
  .filter 'agent', (Meta) ->
    agents = Meta.cache('/api/item/meta/userList').query()
    (id) ->
      angular.forEach agents, (value, key) ->
        if value.id is id
          id = value.name
      id