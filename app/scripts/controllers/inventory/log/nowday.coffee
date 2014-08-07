'use strict'

angular.module('laravelUiApp').controller 'InventoryNowdayCtrl', ($scope, Meta, factoryPaging) ->
  $scope.invsSearch = {}

  Meta.cache('/api/item/meta/warehouseList').query (result) ->
    $scope.warehouseLists = result

  Meta.cache('/api/item/info').query (result) ->
    $scope.itemLists = result


  callback = (pg, size) ->
    params = {}
    params.pg = pg || 1
    params.size = size || 20
    params.warehouse_id = if $scope.invsSearch.warehouse then $scope.invsSearch.warehouse.id else ''
    params.item_id = if $scope.invsSearch.item then $scope.invsSearch.item.id else ''
    params.status = []
    if $scope.invsSearch.status
      if $scope.invsSearch.status.onroad
        params.status.push "1"
      if $scope.invsSearch.status.stocked
        params.status.push "0"

    $scope.inventories = Meta.cache('/api/inventory/nowday').query params

  $scope.invsSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.invsSearch.size