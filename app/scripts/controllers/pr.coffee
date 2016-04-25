'use strict'

angular.module('laravelUiApp')
  .controller 'PrCtrl', ($scope, $meta, Meta) ->

    $scope.warehouses = $meta 'whlist'
    $scope.skus = $meta 'itemlist'
    $scope.status = $meta 'prstatuslist'
    $scope.types = $meta 'prtypelist'
    $scope.platforms = $meta 'platformlist'

    Clazz = Meta.store('/api/purchase/request/:id', {id: '@id'})
    Detail = Meta.store '/api/purchase/requestDetail/:id', {id: '@id'}, {update: {method: 'PUT'}}
      
    initCreating = ->
      $scope.creating = 
        status: 'pending'
        type: 'Shipment'
        relation_id: 0

    initCreating()

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
      $('#createPanel').foundation('reveal', 'open')
      initCreating()
      $scope.minDate = new Date()
        # obj = new Clazz {id: 'new'}
        # obj.$get (rtn) ->
        #   $scope.creating = rtn
        #   $scope.minDate = new Date()
        #   $('#createPanel').foundation('reveal', 'open')

    $scope.$watch 'creating.platform', ->
      (new Clazz {id: 'new'}).$get {platform: $scope.creating.platform}, (rtn) ->
        $scope.creating.invoice = rtn.invoice

    $scope.save = ->
      (new Clazz $scope.creating).$save ->
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