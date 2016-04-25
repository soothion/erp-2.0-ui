'use strict'

angular.module('laravelUiApp')
  .controller 'PrvCtrl', ($scope, $routeParams, Meta) ->

    Meta.store('/api/purchase/request/:id', {id: $routeParams.id}).get (rtn) ->
      $scope.request = rtn
      $scope.request.$id = $routeParams.id
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
