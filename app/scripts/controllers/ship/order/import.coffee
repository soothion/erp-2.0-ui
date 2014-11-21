'use strict'

angular.module('laravelUiApp')
  .controller 'OrderImportCtrl', ($filter, $scope, $meta) ->
    $scope.date = new Date(2014, 7, 7);

    init = ->
      $scope.search = {}
      $scope.search.platform = 'amazon'
      $scope.search.channel_id = 1

    init()  