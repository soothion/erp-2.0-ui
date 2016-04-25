'use strict'

angular.module('laravelUiApp')
  .factory 'Message', ($rootScope) ->

    # Public API here
    {
      show: (message) ->
        $rootScope.flash = message

      clear: ->
        $rootScope.flash = ''
    }
