'use strict'

angular.module('laravelUiApp').filter 'quotation', (Meta) ->
  quotations = Meta.cache('/api/purchase/quotation').query()
  (id) ->
    for quotation in quotations
      if quotation.id == id
        return quotation


angular.module('laravelUiApp').filter 'quotationVendorId', ->
  (quotation) ->
    if quotation
      return quotation.vendor_id

angular.module('laravelUiApp').filter 'quotationSPQ', ->
  (quotation) ->
    if quotation
      return quotation.spq