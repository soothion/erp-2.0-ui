'use strict'

angular.module('laravelUiApp')
.controller 'NavbarCtrl', ($scope, $rootScope, $location, Cache, Auth) ->
  $rootScope.theme = Cache.get 'theme' || 'default'
  $scope.themes = ['default', 'amelia', 'cerulean', 'cosmo', 'cyborg', 'flatly', 'journal', 'readable', 'simplex', 'slate', 'spacelab', 'united']

  $scope.switch_theme = (theme) ->
    $rootScope.theme = theme
    Cache.set 'theme', theme
  
  $scope.user = Cache.get 'auth.user'

  $scope.logout = ->
    Auth.logout ->
      $location.path('/login')

  $scope.routeIs = (routeName) ->
    $location.path().indexOf(routeName) == 0
  $scope.show = ->
    Auth.isLoggedIn()
