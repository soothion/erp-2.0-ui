'use strict'

angular.module('laravelUiApp')
  .filter 'timer', () ->
    (input) ->
      t = input.split /[- :]/
      Date.parse (new Date t[0], t[1]-1, t[2], t[3], t[4], t[5])