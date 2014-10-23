'use strict'

angular.module('laravelUiApp').controller 'StockAllocationAsksCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.asksSearch = {}

  Meta.cache('/api/item/info').query (result) ->
    $scope.itemLists = result

  Meta.cache('/api/item/meta/warehouseList').query (result) ->
    $scope.warehouseLists = result

  Meta.cache('/api/purchase/vendor').query (result) ->
    $scope.vendorLists = result

  $scope.statusLists = ['pending', 'confirmed', 'complete']

  callback = (page, size) ->
    $scope._asks = []
    params = {}
    params.page = page || 1
    params.size = size || 20
    params.from_platform_id = $scope.asksSearch.from_platform_id
    params.warehouse_id = $scope.asksSearch.warehouse_id
    params.item_id = $scope.asksSearch.item_id
    params.status = $scope.asksSearch.status
    $scope.asks = $resource('/api/stock/allocation/ask', {}, {lists: {method: 'GET', isArray: true}}).lists params, ->
      angular.forEach $scope.asks, (ask, i) ->
        $scope._asks[i] = {}
        angular.forEach ask, (val, key) ->
          $scope._asks[i][key] = val
        true
      true
    return $scope.asks

  $scope.asksSearch.size = 20;
  $scope.paging = factoryPaging callback, $scope.asksSearch.size

  $scope.clean = ->
    $scope.asksSearch = {}
    $scope.paging.first()

  $scope.append = ->
    param = {}
    param.from_platform_id = $scope.askRecord.from_platform_id
    param.item_id = $scope.askRecord.item_id
    param.warehouse_id = $scope.askRecord.warehouse_id
    param.qty = $scope.askRecord.qty
    $resource('/api/stock/allocation/ask', {}, {append: {method: 'POST'}}).append param, ->
      $('#myModal').foundation('reveal', 'close')
      #$scope.paging = factoryPaging callback, $scope.asksSearch.size
      $scope.paging.fetch()
      true
    param = $scope.askRecord = {}

  $scope.confirm = (key) ->
    $resource('/api/stock/allocation/ask/confirm/:id', {id: '@id'}, {'confirm': {method: 'GET'}}).confirm {id: $scope.asks[key].id}, ->
      $scope.asks[key].status = 'confirmed';
    true

  $scope.modify = (key) ->
    $resource('/api/stock/allocation/ask/:id', {id: '@id'}, {'save': {method: 'PUT'}}).save $scope.asks[key], ->
      $scope._asks[key].item_id = $scope.asks[key].item_id
      $scope._asks[key].from_platform_id = $scope.asks[key].from_platform_id
      $scope._asks[key].warehouse_id = $scope.asks[key].warehouse_id
      $scope._asks[key].qty = $scope.asks[key].qty
      true
    true

  $scope.rollback = (key) ->
    $scope.asks[key].item_id = $scope._asks[key].item_id
    $scope.asks[key].qty = $scope._asks[key].qty
    $scope.asks[key].from_platform_id = $scope._asks[key].from_platform_id
    true

  $scope.remove = (key) ->
    $resource('/api/stock/allocation/ask/:id', {id: '@id'}, {'remove': {method: 'DELETE'}}).delete {id: $scope.asks[key].id}, ->
      #$scope.paging = factoryPaging callback, $scope.asksSearch.size
      $scope.paging.fetch()
      true
    true

  $scope.showModal = ->
    $('#myModal').foundation('reveal', 'open')
    true
