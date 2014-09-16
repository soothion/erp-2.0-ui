'use strict'

angular.module('laravelUiApp')
  .controller 'PrCtrl', ($scope, $meta, Meta) ->

    $scope.warehouses = $meta 'whlist'
    $scope.skus = $meta 'itemlist'
    $scope.status = $meta 'prstatuslist'
    $scope.types = $meta 'prtypelist'

    Clazz = Meta.store('/api/purchase/request/:id', {id: '@id'})
    Detail = Meta.store '/api/purchase/requestDetail/:id', {id: '@id'}, {update: {method: 'PUT'}}

    $scope.toFilter = ->
      Clazz.query $scope.searchModel, (rtn) ->
        $scope.requests = rtn

    $scope.view = (obj) ->
      obj.$get ->
        $scope.holder = obj
        $('#viewPanel').foundation('reveal', 'open')
        Detail.query {'rid': obj.id}, (rtn) ->
          obj.details = rtn

    $scope.toCreate = ->
        obj = new Clazz {id: 'new'}
        obj.$get (rtn) ->
          $scope.creating = rtn
          $scope.minDate = new Date()
          $('#createPanel').foundation('reveal', 'open')

    $scope.save = ->
      $scope.creating.$save ->
        $('#viewPanel').foundation('reveal', 'close')
        $scope.toFilter()

    $scope.confirm = (id) ->
      Meta.store('/api/purchase/request-confirm/:id', {id: id}).get ->
        $scope.toFilter()

    $scope.unconfirm = (id) ->
      Meta.store('/api/purchase/request-unconfirm/:id', {id: id}).get ->
        $scope.toFilter()

    $scope.destory = (id) ->
      Clazz.remove ->
        $scope.toFilter()