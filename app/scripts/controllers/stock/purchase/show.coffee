'use strict'

angular.module('laravelUiApp').controller 'StockPurchaseShowCtrl', ($scope, $routeParams, $resource, Meta) ->
  order = {}
  $scope.order = order = $resource('/api/stock/purchase/:id', {id: '@id'}, {query: {method: 'GET'}}).query {id: $routeParams.id}

  $scope.isQtyFull = (qty_rest) ->
    return qty_rest == 0

  $scope.genStockIO = ->
    $resource('/api/stock/purchase/:id', {id: '@id'}, {genStockIO: {method: 'PUT'}}).genStockIO order, ->
      window.location.reload()
