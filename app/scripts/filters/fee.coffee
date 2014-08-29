'use strict'

angular.module('laravelUiApp')
  .filter 'fee', ($filter) ->
    (item, wid, trans) ->
      c = $filter('filter')(item.cost, {warehouse_id: wid})[0]
      mv = item.packing_width * item.packing_height * item.packing_length / 5000
      (if trans == 'sea' then c.sea_cost * (item.packing_weight / mv) else c.air_cost * mv) if c?