'use strict'

angular.module('laravelUiApp')
  .controller 'PoecCtrl', ($scope, $routeParams, Meta) ->
    
    Meta.cache('/api/item/meta/warehouseList').query (rtn) ->
      $scope.whs = rtn
    Meta.cache('/api/item/meta/transportList').query (rtn) ->
      $scope.trans = rtn
    Meta.cache('/api/platforms').query (rtn) ->
      $scope.platforms = rtn
    Meta.cache('/api/item/info').query (rtn) ->
      $scope.skus = rtn
    Meta.cache('/api/item/meta/taxList/:id', {id: '@id'}).query (rtn) ->
      $scope.taxs = rtn
    Meta.cache('/api/purchase/vendor/:id', {id: '@id'}).query (rtn) ->
      $scope.vendors = rtn

    $scope.currencies = ['CNY', 'USD']

    $scope.plan_id = null

    store = Meta.store('/api/purchase/exec/:id', {id : '@id'}, {
      getDetailList: {method: 'GET', isArray: true}
      confirmList: {method: 'GET', isArray: true, params: {id: 'confirmed'}}
    })

    init = ->
      store.confirmList (rtn) ->
        $scope.plans = rtn

    init()

    $scope.csearch = ->
      Meta.store('/api/purchase/assign/:id', {id: '@id'}).query $scope.searchform, (rtn) ->
        $scope.assigns = rtn