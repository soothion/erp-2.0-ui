'use strict'

angular.module('laravelUiApp')
  .controller 'PreCtrl', ($scope, $routeParams, $modal, flash, Meta) ->

    $scope.brand = brand = $routeParams.id == 'new'

    # 基础信息获取
    Meta.cache('/api/item/meta/requestStatus').query (rtn) ->
      $scope.status = rtn
    Meta.cache('/api/item/meta/requestTypes').query (rtn) ->
      $scope.types = rtn
    Meta.cache('/api/item/meta/warehouseList').query (rtn) ->
      $scope.whs = rtn
    Meta.cache('/api/item/info').query (rtn) ->
      $scope.skus = rtn
    Meta.cache('/api/item/meta/warehouseList').query (rtn) ->
      $scope.whs = rtn
    Meta.cache('/api/platforms').query (rtn) ->
      $scope.platforms = rtn
    Meta.cache('/api/item/meta/transportList').query (rtn) ->
      $scope.trans = rtn

    [$scope.holder, $scope.opened] = [{}, {}]
    $scope.minDate = new Date()
    $scope.open = ($event, index) ->
      $event.preventDefault()
      $event.stopPropagation()
      switch_datepicker index

    switch_datepicker = (idx) ->
      angular.forEach $scope.opened, (value, key) ->
        $scope.opened[key] = false
      $scope.opened[idx] = true

    filter_date = (dt = '') ->
      t = dt.split /[- :]/
      new Date t[0], t[1]-1, t[2], t[3], t[4], t[5]

    $scope.loadMaster = ->
      Meta.store('/api/purchase/request/:id').get {id: $routeParams.id}, (rtn) ->
        rtn.expired_at = filter_date rtn.expired_at
        angular.forEach rtn.details, (v, k) ->
          rtn.details[k].end_date = filter_date(v.end_date)
        $scope.request = rtn
        $scope.remote = angular.copy rtn
        $scope.request.$id = $routeParams.id

    $scope.loadMaster()

    $scope.isClean = ->
      angular.equals $scope.remote, $scope.request

    $scope.isHolderClean = ->
      angular.equals $scope.holder_origin, $scope.holder_detail

    $scope.details_new = ->
      $scope.request.details.push {}

    $scope.details_remove = (id) ->
      $scope.request.details.splice id, 1

    $scope.confirm = (id) ->
      Meta.store('/api/purchase/request-confirm/:id', {id: $routeParams.id}).get ->
        $scope.loadMaster()

    $scope.unconfirm = (id) ->
      Meta.store('/api/purchase/request-unconfirm/:id', {id: $routeParams.id}).get ->
        $scope.loadMaster()

    $scope.reset = ->
      $scope.request = angular.copy $scope.remote

    $scope.update = if brand then ->
      Meta.store('/api/purchase/request/:id', {id: $routeParams.id}).save $scope.request, ->
        flash.success = '保存申购单成功'
        $scope.loadMaster()
    else ->
      Meta.store('/api/purchase/request/:id', {id: $routeParams.id}, {update: {method: 'put'}}).update $scope.request, ->
        flash.success = '修改申购单成功'
        $scope.loadMaster()

    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
