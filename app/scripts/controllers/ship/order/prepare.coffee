'use strict'

angular.module('laravelUiApp')
  .controller 'OrderPrepareCtrl', ($filter, $scope, $meta) ->
    $scope.date = new Date(2014, 7, 7);

    item = 
      packing_weight: 10
      packing_width: 20
      packing_height: 30
      packing_length: 40
      cost:[
        warehouse_id: 1, sea_coast: 100
      ]
