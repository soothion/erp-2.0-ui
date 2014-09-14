'use strict'

angular.module('laravelUiApp')
  .directive('filter', ($filter, $meta) ->
    restrict: 'E'
    scope:
      'id': '='
      'key': '@'
    link: (scope, element, attrs) ->
      list = $meta(scope.key)

      if list.$resolved? then list.$promise.then (result) ->
        element.text ($filter('filter') result, {id: parseInt scope.id}, true)[0]?.name || scope.id
      else
        element.text ($filter('filter') list, {id: parseInt scope.id}, true)[0]?.name || scope.id
  )
