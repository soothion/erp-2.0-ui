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

    Meta.cache('/api/purchase/quotation').query (result) ->
      $scope.quotations = result

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
      params = $scope.searchform
      params.item_id = if $scope.searchform.sku then $scope.searchform.sku.id else ''
      params.vendor_id = if $scope.searchform.vendor then $scope.searchform.vendor.id else ''
      # Meta.store('/api/purchase/exec/:id', {id: '@id'}).query $scope.searchform, (rtn) ->
        # $scope.assigns = rtn
      Meta.store('/api/purchase/exec/:id', {id: '@id'}).query params, (rtn) ->
        $scope.plandetails = rtn
        for detail in $scope.plandetails
          $scope.updateDataAfterChangedVendor(detail)

#    $scope.updateDataAfterChangedVendor = (detail) ->
#      Meta.cache('/api/item/vendorItem').save {item_id: detail.item.id, vendor_id: detail.vendor.id}, (rtn) ->
#        [detail.spq, detail.price_type, detail.unit_price] = [rtn.spq, rtn.price_type, rtn.unit_price]

    $scope.updateDataAfterChangedVendor = (detail) ->
      for quotation in $scope.quotations
        if detail.item_id == quotation.item_id and detail.vendor.id == quotation.vendor_id
          [detail.spq, detail.quotation_id, detail.tax_rate, detail.invoice_rate, detail.currency] = [quotation.spq, quotation.id, quotation.tax_rate, quotation.invoice_rate, quotation.currency]
          $scope.fetchPrice(detail, quotation.id)
          return quotation
      [detail.spq, detail.quotation_id, detail.tax_rate, detail.invoice_rate] = [0, 0, 0, 0]

    $scope.fetchPrice = (detail, quotationId) ->
      switch detail.price_type
        when "tax", "TAX" then detail.unit_price = $scope.quotations[quotationId].tax_unit_price
        when "usd", "USD" then detail.unit_price = $scope.quotations[quotationId].usd_unit_price
        else
          detail.unit_price = $scope.quotations[quotationId].unit_price
          detail.price_type = "normal"

    $scope.calcPurchaseQty = (detail) ->
      detail.to_purchase_qty = detail.real_qty - detail.stock_qty

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
          $scope.order={}
          $scope.order.vendor_id = $scope.commonVendorId
          $scope.order.warehouse_id = $scope.commonWarehouseId
          $scope.order.price_type = $scope.commonTax
          $scope.order.tax_rate = $scope.commonTaxRate
          $scope.order.invoice_rate = $scope.commonInvoiceRate
          $scope.order.status="pending"
          $scope.order.plan_id = $scope.searchform.plan_id
          $scope.order.note = $scope.order.note || ''
          $scope.order.delivery_date = $scope.order.delivery_date || ''
          $scope.order.ship_to = $scope.order.ship_to || ''
          $scope.order.transportation = $scope.commonTrans
          $scope.order.currency = $scope.commonCurrency
          $scope.order.total = 0
          for detailSelected in $scope.SysMakedOrderDetail
            $scope.order.total += $scope.getTotal(detailSelected)
          Meta.store('/api/purchase/po/invoice/new').get (data) ->
            $scope.order.invoice = data.invoice
          Meta.store('/api/purchase/vendor/:id', {id: $scope.order.vendor_id}).get (data) ->
            $scope.order.payment_method = data.payment_method
            $scope.order.payment_terms = data.payment_terms
            $scope.order.payment_period = data.payment_period

          jQuery('#makeOrderFormNew').foundation('reveal', 'open')
        true


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

          if !$scope.commonTaxRate
            $scope.commonTaxRate = value.tax_rate
          else
            if $scope.commonTaxRate != value.tax_rate
              flash.error = '所选明细的税点不同'
              pass = false

          if !$scope.commonInvoiceRate
            $scope.commonInvoiceRate = value.invoice_rate
          else
            if $scope.commonInvoiceRate != value.invoice_rate
              flash.error = '所选的明细的票点不同'
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
              flash.error = '所选明细的价格类型不同'
              pass = false

          if ! $scope.commonTrans
            $scope.commonTrans = value.transportation
          else
            if $scope.commonTrans != value.transportation
              flash.error = '所选明细的供应商运输方式不同'
              pass = false

          if !$scope.commonCurrency
            $scope.commonCurrency = value.currency
          else
            if $scope.commonCurrency != value.currency
              flash.error = '所选明细的货币不同'
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
      params = {master: $scope.order, childs: []}
      angular.forEach $scope.SysMakedOrderDetail, (item, key) ->
        item.planDetailId = item.id
        item.vendor_id = $scope.commonVendorId
        params.childs.push item
      Meta.store('/api/purchase/po/:operation/:id', {id: '@id', operation: 'generate'}).save params, ->
        1
        #window.location.reload()

    $scope.getTotal = (detail) ->
      if detail && detail.to_purchase_qty && detail.unit_price
        detail.to_purchase_qty * detail.unit_price
      else
        0

    $scope.checkAll = ->
      o = jQuery('#all')
      isCheckAll = o.prop('checked')

      if isCheckAll
        for index in $scope.plandetails
          $scope.selectObj.push index.id
      else
        $scope.selectObj = []

      if isCheckAll
        jQuery('.check-list :checkbox').prop('checked', true)
      else
        jQuery('.check-list :checkbox').prop('checked', false)