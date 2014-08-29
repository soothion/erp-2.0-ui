'use strict'

angular.module('laravelUiApp')
  .controller 'PcpCtrl', ($scope, Meta) ->

    Meta.cache('/api/item/meta/warehouseList').query (rtn) ->
      $scope.whs = rtn
    Meta.cache('/api/item/info').query (rtn) ->
      $scope.skus = rtn

    Clazz = Meta.store('/api/purchase/costparams/:id', {id: '@id'}, {update: {method: 'PUT'}})
    load = ->
      Clazz.query (rtn) ->
        $scope.costs = rtn

    load()

    $scope.create = ->
      $('#editForm').foundation('reveal', 'open')
      $scope.holder = {}

    $scope.save = ->
      obj = new Clazz($scope.holder)
      obj.$save (rtn) ->
        $scope.costs.push rtn
        $('#editForm').foundation('reveal', 'close')

    $scope.update = (f1, f2, obj) ->
      obj.$update ->
        fi.$setPristine() for fi in [f1, f2]

    $scope.cancel = (f1, f2, obj) ->
      fi.$setPristine() for fi in [f1, f2]
      obj.$get()

    $scope.remove = (obj) ->
      obj.$delete ->
        load()
