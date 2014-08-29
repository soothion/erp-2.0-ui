'use strict'

angular.module('laravelUiApp')
  .directive('validNumber', () ->
    require: '?ngModel'
    link: (scope, element, attrs, ngModelCtrl) ->
      if !ngModelCtrl
        return

      ngModelCtrl.$parsers.push (val = '0') ->
        clean = val.replace /[^0-9.]+/g, ''
        if val != clean
          ngModelCtrl.$setViewValue clean
          ngModelCtrl.$render()
        clean

      element.bind 'keypress', (event) ->
        if event.keyCode == 32
          event.preventDefault()
  )
