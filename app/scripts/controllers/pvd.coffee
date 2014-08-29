'use strict'

angular.module('laravelUiApp')
  .controller 'PvdCtrl', ($scope, $filter, Meta) ->

    # 供应商列表
    Meta.cache('/api/purchase/vendor/:id').query (rtn) ->
      $scope.vendors = rtn
    Meta.cache('/api/item/info').query (rtn) ->
      $scope.skus = rtn

    Clazz = Meta.store('/api/purchase/packing/:id', {id: '@id'}, {update: {method: 'PUT'}})

    load = ->
      Clazz.query (rtn) ->
        $scope.defaults = rtn

    load()

    $scope.update = (f1, f2, f3, obj) ->
      if f1.$dirty or f2.$dirty or f3.$dirty
        obj.$update ->
          fi.$setPristine() for fi in [f1, f2, f3]

    $scope.cancel = (f1, f2, f3, obj) ->
      fi.$setPristine() for fi in [f1, f2, f3]
      obj.$get()

    $scope.create = ->
      $('#editForm').foundation('reveal', 'open')
      $scope.holder = {}

    $scope.remove = (obj) ->
      obj.$delete ->
        load()

    $scope.save = ->
      obj = new Clazz($scope.holder)
      obj.$save (obj) ->
        $scope.defaults.push obj
        $('#editForm').foundation('reveal', 'close')
