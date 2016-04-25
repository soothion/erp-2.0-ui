'use strict'

angular.module('laravelUiApp')
  .directive('prAudit', () ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text 'this is the prAudit directive'
  )
