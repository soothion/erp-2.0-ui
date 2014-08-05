'use strict'

angular.module('laravelUiApp').controller 'PurchaseOrderListsCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.ordersSearch = {}

  $scope.statusLists = [{'name': 'pending', 'value': 'pending'},
    {'name': 'confirmed', 'value': 'confirmed'},
    {'name': 'partially received', 'value': 'partially received'},
    {'name': 'completely received', 'value': 'completely received'},
    {'name': 'cancel', 'value': 'cancel'}]
  $scope.ordersSearch.status = $scope.statusLists[0]

  $scope.warehouseLists = [{'name': '== 全部仓库 =='},
    {'id': 1, 'name': 'US-CA'},
    {'id': 2, 'name': 'CN-FUTIAN'}]
  $scope.ordersSearch.warehouse = $scope.warehouseLists[0]

  callback = (pg, size) ->
    params = {}

    params.pg = pg || 1
    params.size = size || 20

    $scope.orders = Meta.cache('/api/purchase/po').query params
    return $scope.orders

  $scope.ordersSearch.size = 20
  $scope.paging = factoryPaging callback, $scope.ordersSearch.size

  $scope.cleanSearch = ->
    $scope.ordersSearch = {}
    $scope.ordersSearch.warehouse = $scope.warehouseLists[0]
    $scope.ordersSearch.status = $scope.statueslist[0]
    $scope.paging.first()


  $scope.mergeChecked = ->
    checkList = []
    jQuery("input:checkbox[name='checkIdList']").each( ->
      if jQuery(this).attr('checked') == 'checked'
        id = jQuery(this).val()
        checkList.push id;
    )

    if checkList.length < 2
      alert("合并时，至少选中两项")
    else
      params = {}
      params.orders = checkList
      $resource('/api/purchase/po/merge', {}, {'merge': {method: 'POST'}}).merge params, ->
        window.location.reload()

  $scope.toggleCheckedAll = ->
    o = jQuery("input:checkbox[name='checkAllToggleList']")
    operaToselectAll = o.attr('checked') == 'checked'
    jQuery("input:checkbox[name='checkIdList']").each( ->
      if operaToselectAll
        jQuery(this).attr('checked', true)
      else
        jQuery(this).attr('checked', false)
    )