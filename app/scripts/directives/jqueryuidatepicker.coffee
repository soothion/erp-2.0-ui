'use strict'

angular.module('laravelUiApp')
.directive('jqueryUiDatepicker', () ->
  restrict: 'A'
  require: 'ngModel'
  scope: {
    "value": "=ngModel"
    "minDate": "=minDate"
    "maxDate": "=maxDate"
    "onSelect": "&onSelect"
    }
  link: (scope, element, attrs) ->
    clearListeners = []
    scope.$watch "ready", ->

      element.datepicker({
        defaultDate: scope.value
        dateFormat: 'yy-mm-dd'

        onSelect: ->
          scope.value = $(this).datepicker('getDate')
          scope.onSelect() if angular.isFunction scope.onSelect
          scope.$apply()
      })

      clearListeners.push scope.$watch 'minDate', ->
        element.datepicker "option", "minDate", scope.minDate

      clearListeners.push scope.$watch 'maxDate', ->
        element.datepicker "option", "maxDate", scope.maxDate

    scope.$on '$destroy', ->
      angular.forEach clearListeners, (value, key) ->
        clearListeners[key]()
)