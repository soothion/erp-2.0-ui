'use strict'

angular.module('laravelUiApp')
  .controller 'LoginCtrl', ($scope, $cookieStore, $location, $routeParams, Auth, Meta) ->

    $scope.rtn = $routeParams.rtn || '/'
    $scope.input = {
      username: 'test@test.com'
      password: 'test'
      remember: true
    }

    Meta.flush()

    $scope.login = ->
      user = Auth.login $scope.input, ->
        $location.path $scope.rtn