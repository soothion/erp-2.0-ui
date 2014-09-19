'use strict'

angular.module('laravelUiApp')
  .directive('purchaseExec', ($pe) ->
    restrict: 'A'
    scope:
      'details': '=ngModel'
    link: (scope, element, attrs) ->
      element.after '<div />'
      holder = element.next()[0]
      component = React.renderComponent ($pe {}), holder
      scope.$watch 'details', ->
        component.setState {details: scope.details}
      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder

  )
  .factory '$pe', ($peItem, $peOrder, $filter, $location, Meta) ->
    {div, table, caption, thead, tfoot, tbody, tr, th, td, input, a, ul, li} = React.DOM
    React.createClass
      getInitialState: ->
        details: []
        checking: {}
        selected: {}
        requested: {}
        order: {}
        invoice: null
        show_order: false

      componentDidMount: ->
        Meta.store('/api/purchase/po/invoice/new').get (rtn) =>
          @setState {invoice: rtn.invoice}

      # TODO:还是没有办法解决默认选择的问题
      # componentDidUpdate: ->
        # selected = @state.selected
        # (if not selected[d.id] then selected[d.id] = ($filter('filter') d.item.quotations, {vendor_id: d.item.primary.vendor_id})?[0].id) for d in @state.details if @state.details?
        # @setState {selected: selected}

      handlerCheckAll: (e) ->
        checking = {}
        checking[d.id] = e.currentTarget.checked for d in @state.details
        @setState {checking: checking}

      handlerCheckedChange: (id, checked) ->
        checking = @state.checking
        checking[id] = checked
        @setState {checking: checking}

      handlerVendorChange: (id, qid) ->
        selected = @state.selected
        selected[id] = qid
        @setState {selected: selected}

      handlerRequestedChange: (id, qty) ->
        requested = @state.requested
        requested[id] = parseInt qty
        @setState {requested: requested}

      handlerReqestedMatch: (e) ->
        {details, requested, selected, checking} = @state
        angular.forEach details, (detail, key) ->
          qid = selected[detail.id] || ($filter('filter') detail.item.quotations, {vendor_id: detail.item.primary.vendor_id})?[0].id
          spq = ($filter('filter') detail.item.quotations, {id: qid})?[0].spq
          spq = switch e.currentTarget.title
            when 'round' then Math.round(detail.request_qty/spq) * spq
            when 'up' then Math.ceil(detail.request_qty/spq) * spq
            when 'down' then Math.floor(detail.request_qty/spq) * spq
          if checking[detail.id] then requested[detail.id] = spq
        @setState {requested: requested}

      handlerOrderCreate: (e) ->
        @setState {order: null}
        {details, requested, selected, checking, errors} = @state
        [errors, order_details] = [[], []]
        [_vendor, _warehouse_id, _transportation] = [null, null, null]
        angular.forEach details, (detail, key) =>
          if checking[detail.id]
            quotation = if selected[detail.id] then ($filter('filter') detail.item.quotations, {id: selected[detail.id]})[0] else ($filter('filter') detail.item.quotations, {vendor_id: detail.item.primary.vendor_id})?[0]
            vendor = quotation.vendor
            if _vendor and _vendor.id isnt vendor.id
              errors.push '所选择明细的供应商必须一致'
            if _warehouse_id and _warehouse_id isnt detail.warehouse_id
              errors.push '所选择明细的目的仓必须一致'
            if _transportation and _transportation isnt detail.transportation
              errors.push '所选择明细的运输方式必须一致'

            [_vendor, _warehouse_id, _transportation] = [vendor, detail.warehouse_id, detail.transportation]
            
            detail.item_id = detail.item_id
            # 字符串，不知道存什么的
            detail.size = ''
            detail.qty_confirmed = detail.qty = requested[detail.id] || detail.request_qty
            detail.qty_free = 0
            detail.um = quotation.um
            detail.tax_unit_price = quotation.tax_unit_price
            detail.usd_unit_price = quotation.usd_unit_price
            detail.unit_price = quotation.unit_price
            detail.discount = quotation.vendor.discount_rate
            detail.total = detail.discount * detail.qty
            # 谁可以告诉我这个字段干嘛的
            detail.specification = ''
            detail.unit_price = quotation.unit_price
            detail.invoice_rate = quotation.invoice_rate
            detail.price_type = detail.item.primary.price_type
            order_details.push detail

        if order_details.length is 0
          errors.push '请至少选择一项'

        # 获取公共信息，直接拿一条
        order = 
          # 采购单信息
          invoice: @state.invoice
          plan_id: order_details[0]?.plan_id
          warehouse_id: _warehouse_id
          total: 0
          delivery_date: ''
          payment_dates: 0
          due_date: ''

          # 用户填写
          vendor_invoice: ''
          vendor_invoice_note: ''
          currency: 'CNY'
          currency_rate: 6.294
          tax_rate: ''
          ship_to: _vendor?.delivery_addr

          # 供应商信息
          vendor: _vendor
          vendor_id: _vendor?.id
          note: _vendor?.note
          discount: _vendor?.discount_rate
          payment_method: _vendor?.payment_method
          payment_terms: _vendor?.payment_period

          # 报价级别的属性，不跟随供应商属性
          invoice_rate: ''
          # 报价级别的属性，不同的SKU就算对应相同的供应商，报价属性不一定一致
          price_type: 'normal'
          status: 'pending'
          details: order_details


        if errors.length > 0
          @setState {errors: errors}
        else
          @setState {order: order, show_order: true, errors: errors}

      handlerOrderModify: (e) ->
        @setState {show_order: false}

      handlerOrderSubmit: (e) ->
        order = @state.order
        Meta.store('/api/purchase/order').save order, (rtn) ->
          $location.path('/purchase/order/lists')

      render: ->
        div {}, [
          if not @state.show_order then div {className: 'row'}, [
            div {className: 'columns medium-4'}, [
              if @state.errors?.length > 0 then div {className: 'label alert'}, [
                @state.errors.map (error) ->
                  li {}, error
              ]
            ]
            div {className: 'columns medium-8'}, [
              div {className: 'button-bar right'}, [
                ul {className: 'button-group'}, [
                  li {}, input {type: 'button', className: 'button tiny', title: 'round', value: '按照装箱数四舍五入', onClick: @handlerReqestedMatch}, ''
                  li {}, input {type: 'button', className: 'button tiny', title: 'up', value: '按照装箱数向上', onClick: @handlerReqestedMatch}, ''
                  li {}, input {type: 'button', className: 'button tiny', title: 'down', value: '按照装箱数向下', onClick: @handlerReqestedMatch}, ''
                  li {}, input {type: 'button', className: 'button tiny success', value: '生成采购单', onClick: @handlerOrderCreate}, ''
                ]
              ]
            ]
          ]
          if @state.show_order then div {className: 'row'}, [
            div {className: 'columns, medium-12'}, [
              div {className: 'button-bar right'}, [
                ul {className: 'button-group'}, [
                  li {}, input {type: 'button', className: 'button tiny secondary', value: '返回修改明细', onClick: @handlerOrderModify}
                  li {}, input {type: 'button', className: 'button tiny success', value: '提交采购单', onClick: @handlerOrderSubmit}
                ]
              ]
            ]
          ]
          if not @state.show_order then table {width: '100%'}, [
            thead {}, [
              tr {}, [
                th {}, [
                  input {type: 'checkbox', defaultChecked: false, onChange: @handlerCheckAll}, ''
                ]
                th {}, '供应商'
                th {}, 'SKU'
                th {}, '仓库'
                th {}, '运输'
                th {}, '需求'
                th {}, 'SPQ'
                th {}, '调整'
                th {}, '税'
                th {}, '单价'
                th {}, '总金额'
                th {}, '账期(天)'
              ]
            ]
            tbody {}, [
              if @state.details then @state.details.map (detail, k) =>
                $peItem
                  detail: detail
                  chekcing: @state.checking[detail.id]
                  selected: @state.selected[detail.id] || ($filter('filter') detail.item.quotations, {vendor_id: detail.item.primary.vendor_id})?[0].id
                  requested: @state.requested[detail.id] || detail.request_qty
                  onCheckedStatusChanged: @handlerCheckedChange
                  onVendorChanged: @handlerVendorChange
                  onRequestedChanged: @handlerRequestedChange
            ]
          ]
          $peOrder {order: @state.order} if @state.order && @state.show_order
        ]

  .factory '$peItem', ($filter, $label) ->
    {tr, td, input, select, option, span} = React.DOM
    React.createClass
      handlerCheckedChange: (e) ->
        @props.onCheckedStatusChanged(@props.detail.id, e.currentTarget.checked)
      handlerVendorChange: (e) ->
        @props.onVendorChanged(@props.detail.id, e.currentTarget.value)
      handlerRequestedChange: (e) ->
        @props.onRequestedChanged(@props.detail.id, e.currentTarget.value)
      render: ->
        tr {}, [
          td {}, [
            input {type: 'checkbox', checked: @props.chekcing, onChange: @handlerCheckedChange}
          ]
          td {}, select {value: @props.selected, onChange: @handlerVendorChange}, [
            @props.detail.item.quotations.map (q) =>
              option {value: q.id}, "#{q.vendor.abbreviation}(#{q.vendor.code})"
          ]
          td {}, $label {id: @props.detail.item_id, key: 'itemlist', field: 'sku'}
          td {}, $label {id: @props.detail.warehouse_id, key: 'whlist'}
          td {}, @props.detail.transportation
          td {}, @props.detail.request_qty
          td {}, ($filter('filter') @props.detail.item.quotations, {id: @props.selected})?[0].spq
          td {width: '90'}, input {type: 'text', value: @props.requested, onChange: @handlerRequestedChange}
          td {}, ($filter('filter') @props.detail.item.quotations, {id: @props.selected})?[0].tax_rate
          td {}, $filter('currency') ($filter('filter') @props.detail.item.quotations, {id: @props.selected})?[0].unit_price
          td {}, $filter('currency') ($filter('filter') @props.detail.item.quotations, {id: @props.selected})?[0].unit_price * @props.requested
          td {}, ($filter('filter') @props.detail.item.quotations, {id: @props.selected})?[0].vendor.payment_period
        ]

  .factory '$peOrder', ($label, $filter) ->
    {div, label, span, input, select, option, textarea, table, thead, tbody, tr, th, td} = React.DOM
    React.createClass
      render: ->
        div {className: 'panel'}, [
          div {className: 'row'}, [
            div {className: 'columns small-3'}, [
              div {className: ''}, [
                label {className: 'control-label'}, '供应商'
                input {type: 'text', readOnly: true, value: @props.order.vendor.name}
              ]
            ]
            div {className: 'columns small-3'}, [
              div {className: ''}, [
                label {className: 'control-label'}, '币种'
                input {type: 'text', readOnly: true, value: 'CNY'}
              ]
            ]
            div {className: 'columns small-3'}, [
              div {className: ''}, [
                label {className: 'control-label'}, '汇率'
                input {type: 'text', readOnly: true, value: 6.294}
              ]
            ]
            div {className: 'columns small-3'}, [
              div {className: ''}, [
                label {className: 'control-label'}, '供应商发票号'
                input {type: 'text', readOnly: true, value: @props.order.vendor_invoice}
              ]
            ]
          ]
          div {className: 'row'}, [
            div {className: 'columns small-3'}, [
              div {className: ''}, [
                label {className: 'control-label'}, '税点'
                select {type: 'radio', readOnly: true, value:  0.17}, [
                  [0.17, 0.03, 0].map (d) ->
                    option {value: d}, d
                ]
              ]
            ]
            div {className: 'columns small-3'}, [
              div {className: ''}, [
                label {className: 'control-label'}, '付款方式'
                input {type: 'text', readOnly: true, value: @props.order.vendor.payment_method}
              ]
            ]
            div {className: 'columns small-3'}, [
              div {className: ''}, [
                label {className: 'control-label'}, '帐期'
                input {type: 'text', readOnly: true, value: @props.order.vendor.payment_period}
              ]
            ]
            div {className: 'columns small-3'}, [
              div {className: ''}, [
                label {className: 'control-label'}, 'QQ'
                input {type: 'text', readOnly: true, value: @props.order.vendor.qq}
              ]
            ]
          ]
          # div {className: 'row'}, [
          #   div {className: 'columns small-6'}, [
          #     div {className: ''}, [
          #       label {className: 'control-label'}, '入库仓库'
          #       $label {key: 'whlist', id: @props.order.warehouse_id}
          #     ]
          #   ]
          #   div {className: 'columns small-6'}, [
          #     div {className: ''}, [
          #       label {className: 'control-label'}, '交货时间'
          #       input {type: 'text', value: @props.order.invoice}
          #     ]
          #   ]
          # ]
          div {className: 'row'}, [
            div {className: 'columns small-12'}, [
              div {className: ''}, [
                label {className: 'control-label'}, '送货地址'
                textarea {readOnly: true, value: @props.order.vendor.delivery_addr || '深圳市南山区西丽大勘村工业一路大勘科技园三期3楼'}
              ]
            ]
          ]
          div {className: 'row'}, [
            div {className: 'columns small-12'}, [
              div {className: ''}, [
                label {className: 'control-label'}, '备注'
                textarea {readOnly: true, value: @props.order.vendor.note}
              ]
            ]
          ]
          table {width: '100%'}, [
            thead {}, [
              tr {}, [
                th {}, 'SKU'
                th {}, '期初库存'
                th {}, '采购数量'
                th {}, '参考单价'
                th {}, '含税单价'
                th {}, '美元单价'
                th {}, '报价类型'
                th {}, '总价'
              ]
            ]
            tbody {}, [
              if @props.order.details then @props.order.details.map (d) ->
                tr {}, [
                  td {}, d.item.sku
                  td {}, d.real_qty
                  td {}, d.qty
                  td {}, $filter('currency') d.unit_price, '￥'
                  td {}, $filter('currency') d.tax_unit_price, '￥'
                  td {}, $filter('currency') d.usd_unit_price
                  td {}, d.price_type
                  td {}, $filter('currency') d.unit_price * d.qty, '￥'
                ]
            ]
          ]
        ]
