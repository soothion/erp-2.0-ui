'use strict'

angular.module('laravelUiApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.date = new Date(2014, 7, 7);

    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
