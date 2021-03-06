'use strict'

angular.module('laravelUiApp')
  .controller 'OrderAnalyzingCtrl', ($scope, Meta) ->

    Clazz = Meta.store('/api/ship/analyzing/:id', {id: '@id'})
    Model = Meta.store('/api/ship/analyzing/:platform', {platform: '@platform'})

    init = ->
      $scope.search = {}
      $scope.search.group = 'date';


    init()  

    $scope.load = (group) ->
      $scope.search.group = group
      Clazz.query $scope.search, (rtn) ->
        $scope.list = rtn

    
    $scope.create = ->
      $scope.model = {}
      $scope.model.platform = $scope.search.platform
      $scope.model.channel_id = $scope.search.channel_id
      obj = new Model {platform: $scope.search.platform}
      obj.$get (rtn) ->
        $scope.model.config = rtn
      $('#model').foundation('reveal', 'open')
      false

    $scope.edit = (obj) ->
      obj.config = eval "("+obj.config+")"
      $scope.model = obj
      $('#model').foundation('reveal', 'open')
      false

    $scope.save = ->
      $scope.model.config = JSON.stringify $scope.model.config
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