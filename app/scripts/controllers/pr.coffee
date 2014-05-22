'use strict'

angular.module('laravelUiApp')
  .controller 'PrCtrl', ($scope, Meta) ->

    Meta.cache('/api/item/meta/requestStatus').query (rtn) ->
      $scope.status = rtn

    Meta.cache('/api/item/meta/requestTypes').query (rtn) ->
      $scope.types = rtn

    Meta.cache('/api/item/meta/warehouseList').query (rtn) ->
      $scope.warehouses = rtn

    Meta.cache('/api/item/info').query (rtn) ->
      $scope.skus = rtn

    $scope.toFilter = ->
      Meta.store('/api/purchase/request/:id').query $scope.searchModel, (rtn) ->
        $scope.requests = rtn

    $scope.toFilter()

    $scope.confirm = (id) ->
      Meta.store('/api/purchase/request-confirm/:id', {id: id}).get ->
        $scope.toFilter()

    $scope.unconfirm = (id) ->
      Meta.store('/api/purchase/request-unconfirm/:id', {id: id}).get ->
        $scope.toFilter()

    $scope.destory = (id) ->
      Meta.store('/api/purchase/request/:id', {id: id}).remove ->
        $scope.toFilter()

    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
