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

    $scope.holder = {}
    $scope.minDate = new Date()
    $scope.open = ($event, index) ->
      console.log index
      $event.preventDefault()
      $event.stopPropagation()
      $scope.opened = true

    $scope.loadMaster = ->
      Meta.store('/api/purchase/request/:id').get {id: $routeParams.id}, (rtn) ->
        t = rtn.expired_at.split /[- :]/
        rtn.expired_at = new Date t[0], t[1]-1, t[2], t[3], t[4], t[5]
        $scope.request = rtn
        $scope.remote = angular.copy rtn
        $scope.request.$id = $routeParams.id
    $scope.loadMaster()

    $scope.isClean = ->
      angular.equals $scope.remote, $scope.request

    $scope.isHolderClean = ->
      angular.equals $scope.holder_origin, $scope.holder_detail

    $scope.details_new = ->
      modalInstance = $modal.open {
        templateUrl: 'requestDetail.html'
        controller: ($scope, $modalInstance, skus, platforms) ->
          $scope.skus = skus
          $scope.platforms = platforms
          $scope.ok = ->
            $modalInstance.close()
          $scope.cancel = ->
            $modalInstance.dismiss 'cancel'
        resolve: {
          skus: ->
            $scope.skus
          platforms: ->
            $scope.platforms
        }
      }

    $scope.confirm = (id) ->
      Meta.store('/api/purchase/request-confirm/:id', {id: $routeParams.id}).get ->
        $scope.loadMaster()

    $scope.unconfirm = (id) ->
      Meta.store('/api/purchase/request-unconfirm/:id', {id: $routeParams.id}).get ->
        $scope.loadMaster()

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
