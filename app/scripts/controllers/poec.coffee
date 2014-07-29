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

    store = Meta.store('/api/purchase/exec/:id', {id : '@id'}, {
      getDetailList: {method: 'GET', isArray: true}
      confirmList: {method: 'GET', isArray: true, params: {id: 'confirmed'}}
    })

    init = ->
      $scope.searchform = {}
      $scope.selectRepeatData = {}
      $scope.selectObj = []
      $scope.SysMakedOrderDetail = []
      store.confirmList (rtn) ->
        $scope.plans = rtn
        $scope.$watch 'searchform', ->
          $scope.csearch()
        , true
        $scope.searchform.plan_id = rtn[-1..][0].id
    init()


    $scope.csearch = ->
      $scope.selectRepeatData = {}
      $scope.selectObj = []
      $scope.SysMakedOrderDetail = []
      $scope.commonTax = $scope.commonTrans = $scope.commonVendorId = $scope.commonWarehouseId = null
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
        $scope.SysMakedOrderDetail = []
        angular.forEach $scope.plandetails, (detail, key) ->
          if detail.id in $scope.selectObj
            $scope.SysMakedOrderDetail.push detail

        # check
        if checkOrderDetail()
          jQuery('#makeOrderFormNew').foundation('reveal', 'open');
          $scope.order={}
          $scope.order.vendor_id = $scope.commonVendorId
          $scope.order.warehouse_id = $scope.commonWarehouseId
          $scope.order.price_type = $scope.commonTax
          $scope.order.status="pending"
          $scope.order.plan_id = $scope.searchform.plan_id
          $scope.order.note = $scope.order.note || ''
          $scope.order.delivery_date = $scope.order.delivery_date || ''
          $scope.order.payment_terms = $scope.order.payment_terms || ''
          $scope.order.ship_to = $scope.order.ship_to || ''
          Meta.store('/api/purchase/po/:operation/:id', {id: 'new', operation: 'invoice'}).get (data) ->
            $scope.order.invoice = data.invoice


    checkOrderDetail = ->
      if $scope.SysMakedOrderDetail.length < 1
        flash.error = 'check:请至少选择一项'
        return false
      else
        pass = true
        angular.forEach $scope.SysMakedOrderDetail, (value, key) ->
          if ! value.warehouse_id
            flash.error = '所选明细的需求仓库未填写'
            pass = false
          if ! value.vendor || ! value.vendor.id
            flash.error = '所选明细的供应商未填写'
            pass = false
          if ! value.price_type
            flash.error = '所选明细的含税方式未填写'
            pass = false
          if ! value.transportation
            flash.error = '所选明细的含税方式未填写'
            pass = false

          if ! $scope.commonWarehouseId
            $scope.commonWarehouseId = value.warehouse_id
          else
            if $scope.commonWarehouseId != value.warehouse_id
              flash.error = '所选明细的需求仓库不同'
              pass = false

          if ! $scope.commonVendorId
            $scope.commonVendorId = value.vendor.id
          else
            if $scope.commonVendorId != value.vendor.id
              flash.error = '所选明细的供应商不同'
              pass = false

          if ! $scope.commonTax
            $scope.commonTax = value.price_type
          else
            if $scope.commonTax != value.price_type
              flash.error = '所选明细的供应商不同'
              pass = false

          if ! $scope.commonTrans
            $scope.commonTrans = value.transportation
          else
            if $scope.commonTrans != value.transportation
              flash.error = '所选明细的供应商不同'
              pass = false

        pass


    $scope.toggleAddData = (detail_id, index) ->
      if $scope.selectRepeatData[index]
        if detail_id not in $scope.selectObj
          $scope.selectObj.push detail_id
      else
        if detail_id in $scope.selectObj
          angular.forEach $scope.selectObj, (value, k) ->
            ($scope.selectObj.splice k, 1) if value == detail_id

    $scope.makeOrder = ->
      params = {master: $scope.order, child: []}
      angular.forEach $scope.SysMakedOrderDetail, (item, key) ->
        item.planDetailId = item.id
        item.vendor_id = $scope.commonVendorId
        params.child.push item
      Meta.store('/api/purchase/po/:operation/:id', {id: '@id', operation: 'generate'}).save params, ->
        console.log 'gotha'

    $scope.getTotal = (detail) ->
      if detail && detail.to_purchase_qty && detail.unit_price
        detail.to_purchase_qty * detail.unit_price
      else
        0
      
      
      
