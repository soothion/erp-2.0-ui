'use strict'

angular.module('laravelUiApp').controller 'StockShipmentCtrl', ($scope, $resource, Meta, factoryPaging) ->
  $scope.shipmentsSearch = {}
  $scope.transportationLists = ['surface', 'air', 'sea']
  $scope.statusLists = ['pending', 'submitted', 'confirmed', 'on-road']
  $scope.pricetypeLists = ['normal', 'tax', 'usd']

  defaultConf = ->
    $scope.newMaster = {}
    $scope.newMaster.price_type = $scope.pricetypeLists[0];
    true

  Meta.cache('/api/item/info').query (result) ->
    $scope.itemLists = result

  Meta.cache('/api/item/meta/warehouseList').query (result) ->
    $scope.warehouseLists = result

  Meta.cache('/api/purchase/vendor').query (result) ->
    $scope.vendorLists = result

  callback = (page, size) ->
    params = {}
    params.page = page || 1
    params.size = size || 20
    params.warehouse_from_id = $scope.shipmentsSearch.warehouse_from_id
    params.warehouse_to_id = $scope.shipmentsSearch.warehouse_to_id
    #$scope.shipments = Meta.cache('/api/stock/shipment').query params
    $scope.shipments = $resource('/api/stock/shipment', {}, {'query': {method: 'GET', isArray: true, cache: false}}).query params
    true

  defaultConf()
  $scope.shipmentsSearch.size = 20
  $scope.modShipmentDels = []
  $scope.modShipmentAdds = []
  $scope.modShipmentUpds = []
  $scope.modShipment = {}
  $scope.paging = factoryPaging callback, $scope.shipmentsSearch.size

  $scope.clean = ->
    $scope.shipmentsSearch = {}
    $scope.paging.first()

  $scope.newMasterModal = ->
    $('#newMasterModal').foundation('reveal', 'open')
    true

  $scope.newMasterBtn = ->
    param = {}
    param = $scope.newMaster
    $resource('/api/stock/shipment', {}, {'store': {method: 'POST'}}).store param, ->
      $scope.paging.fetch()
      defaultConf()
      $('#newMasterModal').foundation('reveal', 'close')
      true
    true

  $scope.modShipmentModal = (key) ->
    $scope.masterId = $scope.shipments[key].id
    $resource('/api/stock/shipment/:id', {id: '@id'}, {query: {method: 'GET', cache: false}}).query {id: $scope.shipments[key].id}, (result) ->
      $scope.modShipment = result
      $scope._modShipment = {}
      angular.forEach $scope.modShipment, (val, key) ->
        $scope._modShipment[key] = val
        true
      $('#modDetailsModal').foundation('reveal', 'open');
      true
    $resource('/api/stock/shipment/details/:id', {id: '@id'}, {'query': {method: 'GET', isArray: true, cache: false}}).query {id: $scope.shipments[key].id}, (result) ->
      $scope.shipmentDetails = result
      $scope._shipmentDetails = []
      angular.forEach $scope.shipmentDetails, (detail) ->
        $scope._shipmentDetails[detail.id] = {}
        angular.forEach detail, (val, key) ->
          if key != 'id'
            $scope._shipmentDetails[detail.id][key] = val
            true
          true
        true
      true
    true

  $scope.newDetail = ->
    $scope.shipmentDetails.push {'item_id': '', 'qty': '', 'platform_id': ''}
    pos = $scope.shipmentDetails.length - 1
    $scope.modShipmentAdds[pos] = $scope.shipmentDetails[pos]
    true

  $scope.updDetail = (key) ->
    if $scope.shipmentDetails[key]['id']?
      $scope.modShipmentUpds[$scope.shipmentDetails[key]['id']] = {}
      if $scope.shipmentDetails[key].item_id != $scope._shipmentDetails[$scope.shipmentDetails[key]['id']]['item_id']
        $scope.modShipmentUpds[$scope.shipmentDetails[key]['id']]['item_id'] = $scope.shipmentDetails[key].item_id
      if $scope.shipmentDetails[key].qty != $scope._shipmentDetails[$scope.shipmentDetails[key]['id']]['qty']
        $scope.modShipmentUpds[$scope.shipmentDetails[key]['id']]['qty'] = $scope.shipmentDetails[key].qty
      if $scope.shipmentDetails[key].platform_id != $scope._shipmentDetails[$scope.shipmentDetails[key]['id']]['platform_id']
        $scope.modShipmentUpds[$scope.shipmentDetails[key]['id']]['platform_id'] = $scope.shipmentDetails[key].platform_id
    true

  $scope.delDetail = (key) ->
    $scope.modShipmentDels.push $scope.shipmentDetails[key]['id'] if $scope.shipmentDetails[key]['id']? and $scope.shipmentDetails[key]['id'] not in $scope.modShipmentDels
    if $scope.shipmentDetails[key]['id']?
      if $scope.shipmentDetails[key]['id'] not in $scope.modShipmentDels
        $scope.modShipmentDel.push $scope.shipmentDetails[key]['id']
      if $scope.shipmentDetails[key]['id'] in $scope.modShipmentUpds
        $scope.modShipmentUpds.splice $scope.shipmentDetails[key]['id'], 1
    else
      $scope.modShipmentAdds.splice key, 1
    $scope.shipmentDetails.splice key, 1
    true

  $scope.modShipmentBtn = ->
    param = {}
    param.master = {}
    angular.forEach $scope.modShipment, (val, key) ->
      param.master[key] = val if val != $scope._modShipment.key
    param.detailsAppend = []
    for i in $scope.modShipmentAdds
      param.detailsAppend.push i if i?
    param.detailsDelete = $scope.modShipmentDels
    param.detailsModify = $scope.modShipmentUpds
    param.id = $scope.masterId
    $resource('/api/stock/shipment/:id', {id: '@id'}, {'modify': {method: 'PUT'}}).modify param, ->
      param = {}
      $scope.master = {}
      $scope.modShipmentDels = []
      $scope.modShipmentAdds = []
      $scope.modShipmentUpds = []
      $scope.paging.fetch()
      $('#modDetailsModal').foundation('reveal', 'close')
      true
    true

  $scope.confirm = (key) ->
    $resource('/api/stock/shipment/confirm/:id', {id: '@id'}, {confirm: {method: 'GET'}}).confirm {id: $scope.shipments[key]['id']}, ->
      $scope.shipments[key]['status'] = 'confirmed'

  $scope.unconfirm = (key) ->
    $resource('/api/stock/shipment/unconfirm/:id', {id: '@id'}, {unconfirm: {method: 'GET'}}).unconfirm {id: $scope.shipments[key]['id']}, ->
      $scope.shipments[key]['status'] = 'pending'

  $scope.delete = (key) ->
    $resource('/api/stock/shipment/:id', {id: '@id'}, {delete: {method: 'DELETE'}}).delete {id: $scope.shipments[key]['id']}, ->
      $scope.paging.fetch()

  $scope.generate = (key) ->
    $resource('/api/stock/shipment/generate/:id', {id: '@id'}, {generate: {method: 'GET'}}).generate {id: $scope.shipments[key]['id']}, ->
      $scope.shipments[key]['status'] = 'submitted'
  
  true
