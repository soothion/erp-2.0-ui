'use strict'

angular.module('laravelUiApp')
  .factory 'Cache', () ->
    # Service logic
    # ...

    meaningOfLife = 42

    # Public API here
    {
      get: (key) ->
        JSON.parse localStorage.getItem(key)
      set: (key, val) ->
        localStorage.setItem key, JSON.stringify(val)
      unset: (key) ->
        localStorage.removeItem key
      clear: ->
        localStorage.clear()
    }
