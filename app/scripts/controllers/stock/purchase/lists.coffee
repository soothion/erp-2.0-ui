'use strict'

angular.module('laravelUiApp').controller 'StockPurchaseListsCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.ordersSearch = {}

  Meta.cache('/api/item/info').query (result) ->
    $scope.itemLists = result

  callback = (pg, size) ->
    params = {}
    params.pg = pg || 1
    params.size = size || 2
    params.item_id = if $scope.ordersSearch.item then $scope.ordersSearch.item.id else ''
    params.description = $scope.ordersSearch.description || ''
    params.invoice = $scope.ordersSearch.invoice || ''

    $scope.orders = Meta.cache('/api/stock/purchase').query params
    return $scope.orders

  $scope.ordersSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.ordersSearch.size

  $scope.cleanSearch = ->
    $scope.ordersSearch = {}
    $scope.paging.first()