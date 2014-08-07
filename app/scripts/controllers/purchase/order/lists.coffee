'use strict'

angular.module('laravelUiApp').controller 'PurchaseOrderListsCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.ordersSearch = {}

  $scope.statusLists = [{'name': 'pending', 'value': 'pending'},
    {'name': 'confirmed', 'value': 'confirmed'},
    {'name': 'partially received', 'value': 'partially received'},
    {'name': 'completely received', 'value': 'completely received'},
    {'name': 'cancel', 'value': 'cancel'}]
  $scope.ordersSearch.status = $scope.statusLists[0]

  Meta.cache('/api/item/meta/warehouseList').query (result) ->
    $scope.warehouseLists = result

# $scope.ordersSearch.warehouse = $scope.warehouseLists

  Meta.cache('/api/system/user').query (result) ->
    $scope.agentLists = result

  Meta.cache('/api/item/info').query (result) ->
    $scope.itemLists = result

  callback = (pg, size) ->
    params = {}

    params.pg = pg || 1
    params.size = size || 20
    params.status = if $scope.ordersSearch.status then $scope.ordersSearch.status.value else ''
    params.agent = if $scope.ordersSearch.agent then $scope.ordersSearch.agent.id else ''
    params.item_id = if $scope.ordersSearch.item then $scope.ordersSearch.item.id else ''
    params.warehouse_id = if $scope.ordersSearch.warehouse then $scope.ordersSearch.warehouse.id else ''
    params.created_at = $scope.ordersSearch.created_at || ''
    params.updated_at = $scope.ordersSearch.updated_at || ''
    params.invoice = $scope.ordersSearch.invoice || ''

    $scope.orders = Meta.cache('/api/purchase/po').query params
    return $scope.orders

  $scope.ordersSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.ordersSearch.size

  $scope.cleanSearch = ->
    $scope.ordersSearch = {}
    $scope.ordersSearch.status = $scope.statusLists
    $scope.paging.first()


  $scope.mergeChecked = ->
    checkList = []
    jQuery("input:checkbox[name='checkIdList']").each( ->
      if jQuery(this).prop('checked')
        id = jQuery(this).val()
        checkList.push id
      id
    )
    checkList

    if checkList.length < 2
      alert("合并时，至少选中两项")
    else
      params = {}
      params.orders = checkList
      $resource('/api/purchase/po/merge', {}, {'merge': {method: 'POST'}}).merge params, ->
        window.location.reload()

  $scope.toggleCheckedAll = ->
    o = jQuery("#checkAllToggleList")
    operaToselectAll = o.prop('checked')
    jQuery("input:checkbox[name='checkIdList']").each( ->
      if operaToselectAll
        jQuery(this).prop('checked', true)
      else
        jQuery(this).prop('checked', false)
    )
    operaToselectAll