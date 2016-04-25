'use strict'

angular.module('laravelUiApp')
  .filter 'fee', ($filter) ->
    (item, wid, trans, qty = 1) ->
      c = $filter('filter')(item.cost, {warehouse_id: wid})?[0]
      mv = item.packing_width * item.packing_height * item.packing_length / 5000
      {
        'sea': $filter('currency') (c.sea_cost * (item.packing_weight / mv) or -1)  * qty
        'air': $filter('currency') (c.air_cost * mv or -1)  * qty
      }[trans] if c?
