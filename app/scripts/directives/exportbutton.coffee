'use strict'

angular.module('laravelUiApp')
  .directive('exportButton', () ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text 'this is the exportButton directive'
  )
