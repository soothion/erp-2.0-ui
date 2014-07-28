'use strict'

angular.module('laravelUiApp')
  .controller 'PvqCtrl', ($scope, Meta) ->

    Meta.store('/api/purchase/quotation/:id', {id: '@id'}).query (rtn) ->
      $scope.quotations = rtn
    
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
