'use strict'

angular.module('laravelUiApp')
  .controller 'PoecCtrl', ($scope, $routeParams, Meta, flash) ->
    
    Meta.cache('/api/item/meta/warehouseList').query (rtn) ->
      $scope.whs = rtn
    Meta.cache('/api/item/meta/transportList').query (rtn) ->
      $scope.trans = rtn
    Meta.cache('/api/platforms').query (rtn) ->
      $scope.platforms = rtn
    Meta.cache('/api/item/info').query (rtn) ->
      $scope.skus = rtn
    Meta.cache('/api/item/meta/taxList/:id', {id: '@id'}).query (rtn) ->
      $scope.taxs = rtn
    Meta.cache('/api/purchase/vendor/:id', {id: '@id'}).query (rtn) ->
      $scope.vendors = rtn

    $scope.currencies = ['CNY', 'USD']

    $scope.plan_id = null

    store = Meta.store('/api/purchase/exec/:id', {id : '@id'}, {
      getDetailList: {method: 'GET', isArray: true}
      confirmList: {method: 'GET', isArray: true, params: {id: 'confirmed'}}
    })

    init = ->
      $scope.searchform = {}
      $scope.selectRepeatData = {}
      $scope.selectObj = []
      $scope.SysMakeOrderDetail = []
      store.confirmList (rtn) ->
        $scope.plans = rtn
        $scope.$watch 'searchform', ->
          $scope.csearch()
        , true
        $scope.searchform.plan_id = rtn[-1..][0].id
    init()


    $scope.csearch = ->
      # Meta.store('/api/purchase/exec/:id', {id: '@id'}).query $scope.searchform, (rtn) ->
        # $scope.assigns = rtn
      Meta.store('/api/purchase/exec/:id', {id: '@id'}).query $scope.searchform, (rtn) ->
        $scope.plandetails = rtn

    $scope.updateDataAfterChangedVendor = (detail) ->
      Meta.cache('/api/item/vendorItem').save {item_id: detail.item.id, vendor_id: detail.vendor.id}, (rtn) ->
        [detail.spq, detail.price_type, detail.unit_price] = [rtn.spq, rtn.price_type, rtn.unit_price]

    $scope.changeMutilDetailQty = (type) ->
      angular.forEach $scope.plandetails, (detail, key) ->
        detail.real_qty = switch type
          when 'middle' then Math.round(detail.request_qty / detail.spq) * detail.spq
          when 'up' then Math.ceil(detail.request_qty / detail.spq) * detail.spq
          when 'down' then Math.floor(detail.request_qty / detail.spq) * detail.spq
        detail.to_purchase_qty = detail.real_qty - parseInt(detail.stock_qty)

    $scope.preActionToMakeOrder = ->
      if $scope.selectObj.length < 1
        flash.error = '请至少选择一项'
      else
        angular.forEach $scope.plandetails, (detail, key) ->
          if detail.id in $scope.selectObj
            $scope.SysMakeOrderDetail.push detail
        jQuery('#makeOrderFormNew').modal();
          

    $scope.toggleAddData = (detail_id, index) ->
      if $scope.selectRepeatData[index]
        if detail_id not in $scope.selectObj
          $scope.selectObj.push detail_id
      else
        if detail_id in $scope.selectObj
          angular.forEach $scope.selectObj, (value, k) ->
            ($scope.selectObj.splice k, 1) if value == detail_id
      
      
