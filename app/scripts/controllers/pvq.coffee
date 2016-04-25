'use strict'

angular.module('laravelUiApp')
  .controller 'PvqCtrl', ($scope, Meta) ->

    pointer = null
    Clazz = Meta.store('/api/purchase/quotation/:id', {id: '@id'})

    load = ->
      Clazz.query (rtn) ->
        $scope.quotations = rtn

    load()
    
    $scope.edit = (index) ->
      pointer = index
      $('#editForm').foundation('reveal', 'open')
      $scope.holder = $scope.quotations[pointer]

    $scope.save = ->
      Clazz.update $scope.holder, ->
        $scope.quotations[pointer] = $scope.holder
        $('#editForm').foundation('reveal', 'close')