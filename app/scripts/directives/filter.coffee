'use strict'

angular.module('laravelUiApp')
  .directive('filter', ($filter, $meta) ->
    restrict: 'E'
    scope:
      'key': '@'
    link: (scope, element, attrs) ->
      list = $meta(scope.key)

      if list.$resolved? then list.$promise.then (result) ->
        element.text ($filter('filter') result, {id: parseInt element.text()}, true)[0]?.name || element.text()
      else
        element.text ($filter('filter') list, {id: parseInt element.text()}, true)[0]?.name || element.text()
  )
