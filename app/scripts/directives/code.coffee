'use strict'

angular.module('laravelUiApp')
  .directive('code', () ->
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text element.html()
  )
