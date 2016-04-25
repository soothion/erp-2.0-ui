'use strict'

angular.module('laravelUiApp')
  .controller 'PvCtrl', ($scope, Meta) ->

    Clazz = Meta.store('/api/purchase/vendor/:id', {id: '@id'})

    load = ->
      Clazz.query (rtn) ->
        $scope.vendors = rtn

    load()

    $scope.edit = (obj) ->
      $('#editForm').foundation('reveal', 'open')
      $scope.holder = obj

    $scope.save = ->
      Clazz.update $scope.holder, ->
        $('#editForm').foundation('reveal', 'close')
