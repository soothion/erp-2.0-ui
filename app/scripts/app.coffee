'use strict'

angular.module('laravelUiApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
  'angularFileUpload'
  'timer'
  'angular-loading-bar'
  'angular-flash.service'
  'angular-flash.flash-alert-directive'
  'mm.foundation'
  'angularUtils.directives.dirPagination'
])
  .config (cfpLoadingBarProvider) ->
    cfpLoadingBarProvider.includeBar = true

  .config (flashProvider) ->
    flashProvider.errorClassnames.push 'alert-danger'

  .config ($routeProvider, $httpProvider) ->
    logOut401 = ['$location', '$q', 'Cache', 'flash', ($location, $q, Cache, flash) ->
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
    ]

    $httpProvider.responseInterceptors.push logOut401
    $routeProvider
      .when '/home',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'

      # item
      .when '/item/list',
        templateUrl: 'views/itemlist.html',
        controller: 'ItemlistCtrl'

      # request
      .when '/purchase/request/list',
        templateUrl: 'views/pr.html'
        controller: 'PrCtrl'
      .when '/purchase/request/view/:id',
        templateUrl: 'views/prv.html'
        controller: 'PrvCtrl'
      .when '/purchase/request/edit/:id',
        templateUrl: 'views/pre.html'
        controller: 'PreCtrl'
      .when '/purchase/request/audit',
        templateUrl: 'views/pra.html'
        controller: 'PraCtrl'

      # plan
      .when '/purchase/plan',
        templateUrl: 'views/pp.html'
        controller: 'PpCtrl'
      .when '/purchase/plan/edit/:id',
        templateUrl: 'views/ppe.html'
        controller: 'PpeCtrl'

      # vendor
      .when '/purchase/vendor',
        templateUrl: 'views/pv.html'
        controller: 'PvCtrl'
      .when '/purchase/quotation',
        templateUrl: 'views/pvq.html'
        controller: 'PvqCtrl'
      .when '/purchase/default',
        templateUrl: 'views/pvd.html'
        controller: 'PvdCtrl'

      # ship
      .when '/ship/import',
        templateUrl: 'views/ship/order/import.html'
        controller: 'OrderImportCtrl'      
      .when '/ship/mapping',
        templateUrl: 'views/ship/order/mapping.html'
        controller: 'OrderMappingCtrl'      
      .when '/ship/cron',
        templateUrl: 'views/ship/order/cron.html'
        controller: 'OrderCronCtrl'      
      .when '/ship/analyzing',
        templateUrl: 'views/ship/order/analyzing.html'
        controller: 'OrderAnalyzingCtrl'      
      .when '/ship/query',
        templateUrl: 'views/ship/order/query.html'
        controller: 'OrderQueryCtrl'
      # .when '/ship/mapping/edit/:id',
      #   templateUrl: 'views/ship/order/mappingEdit.html'
      #   controller: 'OrderMappingCtrl'
      
      # order
      .when '/purchase/order/exec',
        templateUrl: 'views/poec.html'
        controller: 'PoecCtrl'

      .when '/purchase/order/lists',
        templateUrl: 'views/purchase/order/lists.html'
        controller: 'PurchaseOrderListsCtrl'

      .when '/purchase/order/show/:id',
        templateUrl: 'views/purchase/order/show.html'
        controller: 'PurchaseOrderShowCtrl'
        
      .when '/purchase/costparams',
        templateUrl: 'views/pcp.html'
        controller: 'PcpCtrl'

      .when '/inventory/nowday',
        templateUrl: 'views/inventory/inventory/nowday.html'
        controller: 'InventoryNowdayCtrl'

      .when '/inventory/allocations',
        templateUrl: 'views/inventory/log/allocations.html'
        controller: 'InventoryAllocationsCtrl'

      .when '/inventory/books',
        templateUrl: 'views/inventory/log/books.html'
        controller: 'InventoryBooksCtrl'

      .when '/inventory/changes',
        templateUrl: 'views/inventory/log/changes.html'
        controller: 'InventoryChangesCtrl'

      .when '/stock/purchase/lists',
        templateUrl: 'views/stock/purchase/lists.html'
        controller: 'StockPurchaseListsCtrl'

      .when '/stock/purchase/show/:id',
        templateUrl: 'views/stock/purchase/show.html'
        controller: 'StockPurchaseShowCtrl'

      .when '/stock/allocation',
        templateUrl: 'views/stock/allocation/asks.html'
        controller: 'StockAllocationAsksCtrl'

      .when '/stock/allocation/reply',
        templateUrl: 'views/stock/allocation/replys.html'
        controller: 'StockAllocationReplysCtrl'

      .when '/stock/shipment',
        templateUrl: 'views/stock/shipment/index.html'
        controller: 'StockShipmentCtrl'

      .when '/stock/io',
        templateUrl: 'views/stock/io/index.html'
        controller: 'StockIOCtrl'

      .when '/stock/io/lists',
        templateUrl: 'views/stock/io/lists.html'
        controller: 'StockIOListsCtrl'

      .when '/stock/io/show/:id',
        templateUrl: 'views/stock/io/show.html'
        controller: 'StockIOShowCtrl'

      .when '/itemList',
        templateUrl: 'views/itemlist.html'
        controller: 'ItemlistCtrl'
      .otherwise
        redirectTo: '/home'

  .run ($rootScope, $location, Auth) ->
    $rootScope.$on '$routeChangeStart', (event, next, current) ->
      if ! Auth.isLoggedIn()
        $location.path '/login'

