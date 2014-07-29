'use strict'

angular.module('laravelUiApp').controller 'StockIOListsCtrl', ($scope, Meta, factoryPaging) ->
  $scope.ordersSearch = {}

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
  $scope.ordersSearch.type = $scope.typeLists[0]

  $scope.statusLists = [{'name': '== 全部 =='},
    {'name': '已入库', 'value': 1},
    {'name': '未入库', 'value': 0}]
  $scope.ordersSearch.status = $scope.statusLists[0]

  $scope.warehouseLists = [{'name': '== 全部仓库 =='},
    {'id': 1, 'name': 'US-CA'},
    {'id': 2, 'name': 'CN-FUTIAN'}]
  $scope.ordersSearch.warehouse = $scope.warehouseLists[0]

  callback = (pg, size) ->
    params = {}

    params.pg = pg || 1
    params.size = size || 20
    params.invoice = $scope.ordersSearch.invoice || ''
    params.relation_invoice = $scope.ordersSearch.relation_invoice || ''
    params.created_at_from = $scope.ordersSearch.created_at_from || ''
    params.exec_at_to = $scope.ordersSearch.exec_at_to || '';
    params.type = $scope.ordersSearch.type.value || '';
    params.status = if ($scope.ordersSearch.status.value == 0 || $scope.ordersSearch.status == 1) then $scope.ordersSearch.status.value else ''
    params.item_id = if $scope.ordersSearch.item then $scope.ordersSearch.item.id else ''
    params.warehouse_id = $scope.ordersSearch.warehouse.id || ''
    params.vendor_id = if $scope.ordersSearch.vendor then $scope.ordersSearch.vendor.id else ''

    $scope.orders = Meta.cache('/api/stock/io').query params
    return $scope.orders

  $scope.ordersSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.ordersSearch.size

  $scope.cleanSearch = ->
    $scope.ordersSearch = {}
    $scope.ordersSearch.type = $scope.typeLists[0]
    $scope.ordersSearch.status = $scope.statusLists[0]
    $scope.ordersSearch.warehouse = $scope.warehouseLists[0]
    $scope.paging.first()