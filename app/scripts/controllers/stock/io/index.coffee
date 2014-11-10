'use strict'

angular.module('laravelUiApp').controller 'StockIOCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.iosSearch = {}
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


  $scope.statusLists = [{'name': '== 全部 =='},
    {'name': '已入库', 'value': 1},
    {'name': '未入库', 'value': 0}]
  
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
    Meta.cache('/api/stock/io').query (result) ->
      $scope.ios = result
    true

  defaultConf = ->
    $scope.iosSearch.type = $scope.typeLists[0]
    $scope.iosSearch.status = $scope.statusLists[0]
  
  defaultConf()
  $scope.iosSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.iosSearch.size

  $scope.clean = ->
    $scope.iosSearch = {}
    defaultConf()
    $scope.paging.first()

  $scope.showDetailModal = (id) ->
    $('#detailModal').foundation('reveal', 'open')
    $resource('/api/stock/io/details/:id', {}, {'query': {method: 'GET', cache: true, isArray: true}}).query {id: id}, (result) ->
      $scope.ioDetails = result
    true
  
  true
