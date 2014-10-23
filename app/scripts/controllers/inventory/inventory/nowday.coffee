'use strict'

angular.module('laravelUiApp').controller 'InventoryNowdayCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.invsSearch = {}

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
    params.platform_id = $scope.invsSearch.platform_id
    params.item_id = $scope.invsSearch.item_id
    params.warehouse_id = $scope.invsSearch.warehouse_id
    #$scope.invs = Meta.cache('/api/inventory/nowday').query params
    $scope.invs = $resource('/api/inventory/nowday', {}, {'search': {method: 'GET', cache: false, isArray: true}}).search params
    true

  $scope.invsSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.invsSearch.size

  $scope.clean = ->
    $scope.invsSearch = {}
    $scope.paging.first()

  $scope.showAskModal = (key) ->
    $scope.askRecord = {}
    $scope.askRecord.item_id = $scope.invs[key].item_id
    $scope.askRecord.from_platform_id = $scope.invs[key].platform_id
    $scope.askRecord.warehouse_id = $scope.invs[key].warehouse_id
    $('#askModal').foundation('reveal', 'open')
    true

  $scope.showShareModal = (key) ->
    $scope.shareRecord = {}
    $scope.shareRecord.item_id = $scope.invs[key].item_id
    $scope.shareRecord.warehouse_id = $scope.invs[key].warehouse_id
    $('#shareModal').foundation('reveal', 'open')
    true

  $scope.showTofreeModal = (key) ->
    $scope.tofreeRecord = {}
    $scope.tofreeRecord.item_id = $scope.invs[key].item_id
    $scope.tofreeRecord.warehouse_id = $scope.invs[key].warehouse_id
    $('#tofreeModal').foundation('reveal', 'open')
    true

  $scope.showFromfreeModal = (key) ->
    $scope.fromfreeRecord = {}
    $scope.fromfreeRecord.item_id = $scope.invs[key].item_id
    $scope.fromfreeRecord.warehouse_id = $scope.invs[key].warehouse_id
    $('#fromfreeModal').foundation('reveal', 'open')
    true

  $scope.ask = ->
    $resource('/api/stock/allocation/ask', {}, {'ask': {method: 'POST'}}).ask $scope.askRecord, ->
      $scope.askRecord = {}
      $('#askModal').foundation('reveal', 'close')
    true

  $scope.send = ->
    $resource('/api/stock/allocation/send', {}, {'send': {method: 'POST'}}).send $scope.shareRecord, ->
      $scope.shareRecord = {}
      $('#shareModal').foundation('reveal', 'close')
      $scope.paging.fetch()
    true

  $scope.drop = ->
    $resource('/api/stock/allocation/drop', {}, {'drop': {method: 'POST'}}).drop $scope.tofreeRecord, ->
      $scope.tofreeRecord = {}
      $('#tofreeModal').foundation('reveal', 'close')
      $scope.paging.fetch()
    true

  $scope.take = ->
    $resource('/api/stock/allocation/take', {}, {'take': {method: 'POST'}}).take $scope.fromfreeRecord, ->
      $scope.fromfreeRecord = {}
      $('#fromfreeModal').foundation('reveal', 'close')
      $scope.paging.fetch()
    true
