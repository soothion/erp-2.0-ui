'use strict'

angular.module('laravelUiApp')
  .controller 'PvCtrl', ($scope, Meta) ->

    pointer = null
    load = ->
      Meta.cache('/api/purchase/vendor/:id', {id: '@id'}).query (rtn) ->
        $scope.vendors = rtn

    load()

    $scope.edit = (index) ->
      pointer = index
      $('#editForm').foundation('reveal', 'open')
      $scope.holder = $scope.vendors[pointer]

    $scope.save = ->
      Meta.store('/api/purchase/vendor/:id', {id: '@id'}).update $scope.holder, ->
        $scope.vendors[pointer] = $scope.holder
        $('#editForm').foundation('reveal', 'close')
