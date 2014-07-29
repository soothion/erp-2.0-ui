'use strict'

angular.module('laravelUiApp')
  .controller 'PvqCtrl', ($scope, Meta) ->

    pointer = null

    load = ->
      Meta.cache('/api/purchase/quotation/:id', {id: '@id'}).query (rtn) ->
        $scope.quotations = rtn

    load()
    
    $scope.edit = (index) ->
      pointer = index
      $('#editForm').foundation('reveal', 'open')
      $scope.holder = $scope.quotations[pointer]

    $scope.save = ->
      Meta.store('/api/purchase/quotation/:id', {id: '@id'}).update $scope.holder, ->
        $scope.quotations[pointer] = $scope.holder
        $('#editForm').foundation('reveal', 'close')