'use strict'

angular.module('laravelUiApp')
  .controller 'OrderQueryCtrl', ($scope, Meta) ->

    Clazz = Meta.store('/api/ship/query/order/:id', {id: '@id'})
    Detail = Meta.store('/api/ship/query/detail/:id', {id: '@id'})
    Customer = Meta.store('/api/ship/query/customer/:id', {id: '@id'})

    $scope.init = ->
      $scope.list = []
      $scope.tab = 'order'

    $scope.init()

    $scope.load = ->
      Clazz.query $scope.search, (rtn) ->
        $scope.list = rtn
    
    $scope.loadDetail = (order_id) ->
      Detail.query {'order_id': order_id}, (rtn) ->
        $scope.detail = rtn

    $scope.edit = (obj) ->
      $scope.model = obj
      $scope.loadDetail obj.id
      Customer.get {id: obj.customer_id}, (rtn) ->
        $scope.customer = rtn
      $('#model').foundation('reveal', 'open')
      false 

    $scope.create = ->
      $scope.model = {}
      $scope.detail = []
      $scope.customer = {}
      $('#model').foundation('reveal', 'open')
      false

    $scope.save = ->
      if $scope.model.id
        Customer.update $scope.customer
        Clazz.update $scope.model, (rtn) ->
          $scope.model = rtn
      else    
        customer = new Customer($scope.customer)
        customer.$save (rtn) ->
          $scope.customer = rtn
          $scope.model.customer_id = rtn.id
          order = new Clazz($scope.model)
          order.$save (rtn) ->
            $scope.model = rtn
            $scope.list.push rtn
            items = []
            for item in $scope.detail
              item.order_id = rtn.id
              detail = new Detail(item)
              detail.$save (rtn) ->
                items.push rtn
            $scope.detail = items    
      $('#model').foundation('reveal', 'close')
      false

    $scope.remove = (obj) ->
      obj.$delete ->
        $scope.load()   


    $scope.updateSku = (f1, f2, f3, obj) ->
      if obj.id
        Detail.update obj
      else  
        item = new Detail(obj)
        item.$save (item)
      fi.$setPristine() for fi in [f1, f2, f3]

    $scope.createSku = ->
      obj = {}
      obj.order_id = $scope.model.id
      $scope.detail.push(obj)

    $scope.cancelSku = (f1, f2, f3, index) ->
      obj = $scope.detail[index]
      if obj.id 
        obj.$get()
        fi.$setPristine() for fi in [f1, f2, f3] 
      else 
        $scope.detail.splice index, 1   
       

    $scope.removeSku = (index) ->
      obj = $scope.detail[index]
      if obj.id 
        obj.$delete ->
          $scope.loadDetail obj.order_id
      else
        $scope.detail.splice index, 1    