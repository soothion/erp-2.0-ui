'use strict'

angular.module('laravelUiApp')
  .controller 'OrderMappingCtrl', ($scope, Meta) ->

    Clazz = Meta.store('/api/ship/mapping/:id', {id: '@id'})

    init = ->
      $scope.search = {}
      $scope.model = {}
      $scope.search.platform = 'amazon'
      $scope.search.type = 'sku'

    init()  

    $scope.load = ->
      Clazz.query $scope.search, (rtn) ->
        $scope.mappingList = rtn

    $scope.load()
    
    $scope.create = ->
      $scope.model = {}
      $scope.model.platform = $scope.search.platform
      $scope.model.type = $scope.search.type
      $('#model').foundation('reveal', 'open')
      false

    $scope.edit = (obj) ->
      $scope.model = obj
      $('#model').foundation('reveal', 'open')
      false

    $scope.save = ->
      if $scope.model.id
        Clazz.update $scope.model
      else    
        obj = new Clazz($scope.model)
        obj.$save (obj)
      $('#model').foundation('reveal', 'close')
      $scope.load()   

    $scope.remove = (obj) ->
      obj.$delete ->
        $scope.load()   