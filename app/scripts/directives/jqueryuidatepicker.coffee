'use strict'

angular.module('laravelUiApp')
.directive('jqueryUiDatepicker', ($filter) ->
  restrict: 'A'
  require: 'ngModel'
  scope: {
    "value": "=ngModel"
    "minDate": "=minDate"
    "maxDate": "=maxDate"
    "onSelect": "&onSelect"
    }
  link: (scope, element, attrs, ctrl) ->
    clearListeners = []
    clearListener = scope.$watch "ready", ->

      element.datepicker({
        defaultDate: scope.value
        dateFormat: 'yy-mm-dd'

        onSelect: ->
          scope.value = $filter('date') $(this).datepicker('getDate'), 'yyyy-MM-dd'
          ctrl.$setViewValue scope.value
          scope.onSelect() if angular.isFunction scope.onSelect
          scope.$apply()
      })

      if scope.value is undefined or scope.value is null
        watcher = scope.$watch 'value', ->
          scope.value = $filter('date') scope.value, 'yyyy-MM-dd'
          element.datepicker "setDate", scope.value
          watcher()

      clearListeners.push scope.$watch 'minDate', ->
        element.datepicker "option", "minDate", scope.minDate

      clearListeners.push scope.$watch 'maxDate', ->
        element.datepicker "option", "maxDate", scope.maxDate

      clearListener()

    scope.$on '$destroy', ->
      angular.forEach clearListeners, (value, key) ->
        clearListeners[key]()
)