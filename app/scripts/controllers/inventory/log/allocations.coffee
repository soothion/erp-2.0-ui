'use strict'

angular.module('laravelUiApp').controller 'InventoryAllocationsCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.logsSearch = {}

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
    params.from_platform_id = $scope.logsSearch.from_platform_id
    params.to_platform_id = $scope.logsSearch.to_platform_id
    params.warehouse_id = $scope.logsSearch.warehouse_id
    $scope.logs = Meta.cache('/api/inventory/allocations').query params
    true

  $scope.logsSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.logsSearch.size

  $scope.clean = ->
    $scope.logsSearch = {}
    $scope.paging.first()
