'use strict'

angular.module('laravelUiApp').controller 'InventoryNowdayCtrl', ($scope, Meta, factoryPaging) ->
  $scope.invsSearch = {}

  $scope.warehouseLists = [{'name': '== 全部仓库 =='},
    {'id': 1, 'name': 'US-CA'},
    {'id': 2, 'name': 'CN-FUTIAN'}]
  $scope.invsSearch.warehouse = $scope.warehouseLists[0]

  $scope.itemLists = [{'id': 1, 'sku': '001-001-001'},
    {'id': 2, 'sku': '001-001-002'},
    {'id': 3, 'sku': '001-001-003'}]

  callback = (pg, size) ->
    params = {}
    params.pg = pg || 1
    params.size = size || 20
    params.warehouse_id = if $scope.invsSearch.warehouse then $scope.invsSearch.warehouse.id else ''
    params.item_id = if $scope.invsSearch.item then $scope.invsSearch.item.id else ''
    params.status = $scope.invsSearch.status || ''

    $scope.inventories = Meta.cache('/api/inventory/nowday').query params

  $scope.invsSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.invsSearch.size