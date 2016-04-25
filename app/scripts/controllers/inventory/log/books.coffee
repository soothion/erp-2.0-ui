'use strict'

angular.module('laravelUiApp').controller 'InventoryBooksCtrl', ($scope, $resource, Meta, factoryPaging) ->
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
    $scope.logs = Meta.cache('/api/inventory/books').query params
    true

  $scope.logsSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.logsSearch.size

  $scope.clean = ->
    $scope.logsSearch = {}
    $scope.paging.first()
    
  true
