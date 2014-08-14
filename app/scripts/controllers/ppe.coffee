'use strict'

angular.module('laravelUiApp')
  .controller 'PpeCtrl', ($scope, $routeParams, $location, Meta) ->

    $scope.plan = {status: 'confirmed'}

    Meta.store('/api/purchase/plan/:id', {id: $routeParams.id}).get (rtn) ->
      rtn.warehouse = {}
      $scope.plan = rtn

    Meta.store('/api/purchase/cwlist').query (rtn) ->
      $scope.cwlist = rtn

    Meta.store('/api/warehouse/list').query (rtn)->
      $scope.whlist = rtn

    $scope.load = ->
      Meta.store('/api/purchase/plan-summary/:id', {id: $routeParams.id}).query (rtn) ->
        $scope.summary = {}
        $scope.persistent = {}
        angular.forEach rtn, (v, k) ->
          $scope.summary[v.item_id] = v
          $scope.persistent[v.item_id] = angular.copy(v)

      Meta.store('/api/purchase/plan-change/:id', {id: $routeParams.id}).query (rtn) ->
        $scope.changes = rtn

      Meta.store('/api/purchase/plan-free').query (rtn) ->
        $scope.free = rtn

    $scope.load()

    $scope.delta = (id) ->
      n = 0
      angular.forEach $scope.cwlist, (v, k) ->
        n = n + ($scope['summary'][id][v.name + '-' + v.transportation] - $scope['persistent'][id][v.name + '-' + v.transportation])
      n

    $scope.save = ->
      Meta.store('/api/purchase/plan/:id', {id: $routeParams.id}, {update: {method: 'put'}}).update {'plan': $scope.plan, 'detail': $scope.summary}, ->
        alert('计划表修改成功!')
        $scope.load()

    $scope.confirm = ->
      Meta.store('/api/purchase/plan-confirm/:id', {id: $routeParams.id}, {update: {method: 'put'}}).update ->
        alert('计划表确认成功!')
        $location.path('/purchase/plan')

    $scope.isDirty = (id, wh, trans) ->
      $scope['persistent'][id][wh + '-' + trans] != $scope['summary'][id][wh + '-' + trans]

    $scope.isClean = ->
      angular.equals $scope.summary, $scope.persistent

    $scope.canModify = ->
      $scope.plan.status == 'open'

    $scope.add_to_plan = ->
      Meta.store('/api/purchase/plan-add').get ->
        $scope.load()

    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
