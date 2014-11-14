'use strict'

angular.module('laravelUiApp')
  .controller 'ItemlistCtrl', ($scope, Meta) ->

    Store = Meta.store('/api/item/info')
    $scope.items = []
    $scope.totalItems = 0
    $scope.itemsPerPage = 25

    $scope.pagination = 
      current: 1

    $scope.pageChanged = (p) ->
      getResultPage(p)

    getResultPage = (p) ->
      Store.query {kw: $scope.kw, pn: p}, (rtn) ->
        $scope.items = rtn
        # $scope.totalItems = 

    $scope.search = ->
      getResultPage(1)

    $scope.export = ->
      false

    $scope.create = ->
      false
