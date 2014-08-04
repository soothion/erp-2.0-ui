'use strict'

angular.module('laravelUiApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.date = new Date();

    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
