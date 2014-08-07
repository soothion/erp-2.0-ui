'use strict'

angular.module('laravelUiApp').controller 'InventoryChangesCtrl', ($scope, Meta, factoryPaging) ->
  $scope.logsSearch = {}

  $scope.typeLists = [{'name': '== 所有类别 =='},
    {'category': '入库', 'name': '采购入库', 'value': 1},
    {'category': '入库', 'name': '盘盈入库', 'value': 2},
    {'category': '入库', 'name': '加工入库', 'value': 3},
    {'category': '入库', 'name': '调度入库', 'value': 4},
    {'category': '入库', 'name': '拆分入库', 'value': 5},
    {'category': '入库', 'name': '其他入库', 'value': 6},
    {'category': '出库', 'name': '盘亏出库', 'value': -2},
    {'category': '出库', 'name': '加工出库', 'value': -3},
    {'category': '出库', 'name': '调度出库', 'value': -4},
    {'category': '出库', 'name': '拆装出库', 'value': -5},
    {'category': '出库', 'name': '其他出库', 'value': -6},
    {'category': '其他', 'name': '取消关闭', 'value': 7},
    {'category': '其他', 'name': 'FBA Return', 'value': 8},
    {'category': '其他', 'name': 'RMA 回库', 'value': 9},
    {'category': '其他', 'name': '采购退货出库', 'value': 10}]
  $scope.logsSearch.type = $scope.typeLists[0]

  Meta.cache('/api/item/info').query (result) ->
    $scope.itemLists = result

  Meta.cache('/api/item/meta/warehouseList').query (result) ->
    $scope.warehouseLists = result

  Meta.cache('/api/system/user').query (result) ->
    $scope.agentLists = result

  callback = (pg, size) ->
    params = {}
    params.pg = pg || 1
    params.size = size || 20;
    params.warehouse_id = if $scope.logsSearch.warehouse then $scope.logsSearch.warehouse.id else ''
    params.item_id = if $scope.logsSearch.item then $scope.logsSearch.item.id else '';
    params.type = if $scope.logsSearch.type then $scope.logsSearch.type.value else '';
    params.status = $scope.logsSearch.status || '';
    params.relation_id = $scope.logsSearch.relation_id || '';
    params.description = $scope.logsSearch.description || '';
    params.agent = if $scope.logsSearch.agent then $scope.logsSearch.agent.id else '';
    params.updated_from = $scope.logsSearch.updated_from || '';
    params.updated_to = $scope.logsSearch.updated_to || '';

    $scope.logs = Meta.cache('/api/inventory/changes').query params
    return $scope.logs

  $scope.logsSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.logsSearch.size

  $scope.cleanSearch = ->
    $scope.logsSearch = {}
    $scope.logsSearch.type = $scope.typeLists[0]
    $scope.paging.first()
