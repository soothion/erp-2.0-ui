'use strict'

angular.module('laravelUiApp').controller 'StockAllocationReplysCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.replysSearch = {}

  Meta.cache('/api/item/info').query (result) ->
    $scope.itemLists = result

  Meta.cache('/api/item/meta/warehouseList').query (result) ->
    $scope.warehouseLists = result

  Meta.cache('/api/purchase/vendor').query (result) ->
    $scope.vendorLists = result

  $scope.statusLists = ['confirmed', 'complete']

  callback = (page, size) ->
    params = {}
    params.page = page || 1
    params.size = size || 20
    params.to_platform_id = $scope.replysSearch.to_platform_id
    params.warehouse_id = $scope.replysSearch.warehouse_id
    params.item_id = $scope.replysSearch.item_id
    params.status = $scope.replysSearch.status
    $scope.replys = Meta.cache('/api/stock/allocation/reply').query params
    true

  $scope.replysSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.replysSearch.size

  $scope.clean = ->
    $scope.replysSearch = {}
    $scope.paging.first()
  
  $scope.confirm = (key) ->
    $resource('/api/stock/allocation/reply/confirm/:id', {id: '@id'}, {'confirm': {method: 'GET'}}).confirm {id: $scope.replys[key].id}, ->
      $scope.replys[key].status = 'complete'
    true

  $scope.send = ->
    param = {}
    param.to_platform_id = $scope.sendRecord.to_platform_id
    param.item_id = $scope.sendRecord.item_id
    param.warehouse_id = $scope.sendRecord.warehouse_id
    param.qty = $scope.sendRecord.qty
    $resource('/api/stock/allocation/send', {}, {'send': {method: 'POST'}}).send param, ->
      $('#myModal').foundation('reveal', 'close')
      $scope.sendRecord = {}
      true
    true

  $scope.showModal = ->
    $('#myModal').foundation('reveal', 'open')
    true

  true
