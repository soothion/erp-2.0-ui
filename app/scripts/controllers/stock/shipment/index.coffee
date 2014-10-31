'use strict'

angular.module('laravelUiApp').controller 'StockShipmentCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.shipmentsSearch = {}

  Meta.cache('/api/item/info').query (result) ->
    $scope.itemLists = result

  Meta.cache('/api/item/meta/warehouseList').query (result) ->
    $scope.warehouseLists = result

  Meta.cache('/api/purchase/vendor').query (result) ->
    $scope.vendorLists = result

  callback = (page, size) ->
    params = {}
    params.page = page || 1
    params.size = size || 20
    params.warehouse_from_id = $scope.shipmentsSearch.warehouse_from_id
    params.warehouse_to_id = $scope.shipmentsSearch.warehouse_to_id
    $scope.shipments = Meta.cache('/api/stock/shipment').query params
    true

  $scope.shipmentsSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.shipmentsSearch.size

  $scope.clean = ->
    $scope.shipmentsSearch = {}
    $scope.paging.first()

  $scope.newMaster = ->
    $('#newMaster').foundation('reveal', 'open')
    true
    
  true
