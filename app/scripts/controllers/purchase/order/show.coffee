'use strict'

angular.module('laravelUiApp').controller 'PurchaseOrderShowCtrl', ($scope, $resource, $routeParams) ->
  $scope.order = $resource('/api/purchase/po/:id', {id: '@id'}, {'query': {method: 'GET'}}).query {'id': $routeParams.id}

  $scope.confirm = ->
    $resource('/api/purchase/po/confirm/:id', {id: '@id'}, {'confirm': {method: 'GET'}}).confirm {'id': $routeParams.id}, ->
      window.location.reload()

  $scope.unconfirm = ->
    $resource('/api/purchase/po/unconfirm/:id', {id: '@id'}, {'unconfirm': {method: 'GET'}}).unconfirm {'id': $routeParams.id}, ->
      window.location.reload()

  $scope.update = ->
    params = {}
    params.master = $scope.order
    params.master.vendor_id = $scope.order.vendor.id;
    params.master.payment_terms = $scope.order.payment_terms || ''
    params.master.delivery_date = $scope.order.delivery_date || ''
    params.master.note = $scope.order.note || ''
    params.id = $routeParams.id

    params.childs = []
    for i in $scope.order.details
      i.item_id = i.item.id
      i.qty = i.allQty
      i.total = i.unit_price * i.allQty
      i.item = undefined
      params.childs.push i

    params.master.details = undefined

    $resource('/api/purchase/po/:id', {id: '@id'}, {'update': {method: 'PUT'}}).update params, ->
      window.location.reload()
