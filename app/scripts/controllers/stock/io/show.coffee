'use strict'

angular.module('laravelUiApp').controller 'StockIOShowCtrl', ($scope, $routeParams, $resource, Meta) ->
  $scope.order = $resource('/api/stock/io/:id', {id: '@id'}, {'query': {method: 'GET'}}).query {id: $routeParams.id}

  $scope.stockIn = ->
    $resource('/api/stock/io/store/:id', {id: '@id'}, {'toInventory': {method: 'GET'}}).toInventory {id: $routeParams.id}, ->
      window.location.reload()