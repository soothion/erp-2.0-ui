'use strict'

angular.module('laravelUiApp')
  .controller 'PpCtrl', ($scope, Meta) ->
    $scope.load = ->
      Meta.store('/api/purchase/plan').query (rtn) ->
        $scope.plans = rtn
      Meta.store('/api/purchase/plan-free').query (rtn) ->
        $scope.free = rtn

    $scope.load()

    $scope.add_to_plan = ->
      Meta.store('/api/purchase/plan-add').get ->
        $scope.load()

    $scope.create_to_plan = ->
      Meta.store('/api/purchase/plan-create').save {name: $scope.new_plan_name}, ->
        $scope.load()

    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
