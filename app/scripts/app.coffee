'use strict'

angular.module('laravelUiApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ui.bootstrap',
  'angular-loading-bar',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
])
  .config (cfpLoadingBarProvider) ->
    cfpLoadingBarProvider.includeBar = true

  .config (flashProvider) ->
    flashProvider.errorClassnames.push 'alert-danger'

  .config ($routeProvider, $httpProvider) ->
    logOut401 = ($location, $q, Cache, flash) ->
      success = (resp) ->
        flash.error = ''
        resp

      error = (resp) ->
        flash.error = resp.data.error.message

        if resp.status == 401
          Cache.unset 'authenticated'
        if resp.status == 404
          flash.error = '访问的资源不存在（404）'
        console.error flash.error
        $q.reject resp

      (promise) ->
        promise.then success, error

    $httpProvider.responseInterceptors.push logOut401
    $routeProvider
      .when '/home',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
      .when '/purchase/request',
        templateUrl: 'views/pr.html'
        controller: 'PrCtrl'
      .when '/purchase/request/view/:id',
        templateUrl: 'views/prv.html'
        controller: 'PrvCtrl'
      .when '/purchase/request/edit/:id',
        templateUrl: 'views/pre.html'
        controller: 'PreCtrl'
      .when '/purchase/plan',
        templateUrl: 'views/pp.html'
        controller: 'PpCtrl'
      .when '/purchase/plan/edit/:id',
        templateUrl: 'views/ppe.html'
        controller: 'PpeCtrl'
      .otherwise
        redirectTo: '/home'

  .run ($rootScope, $location, Auth) ->
    $rootScope.$on '$routeChangeStart', (event, next, current) ->
      if ! Auth.isLoggedIn()
        $location.path '/login'

