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
  .factory '$pe', ($peItem, $filter) ->
    {div, table, thead, tfoot, tbody, tr, th, td, input, a, ul, li} = React.DOM
    React.createClass
      getInitialState: ->
        details: []
        checking: {}
        selected: {}

      # TODO:还是没有办法解决默认选择的问题
      componentWillReceiveProps: ->
        selected = {}
        selected[d.id] = ($filter('filter') d.item.quotations, {vendor_id: d.item.primary.vendor_id})?[0].id for d in @state.details
        @setState {selected: selected}
        console.log selected

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

      render: ->
        div {}, [
          table {width: '100%'}, [
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
                th {}, '终'
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
                  selected: @state.selected[detail.id]# || ($filter('filter') detail.item.quotations, {vendor_id: detail.item.primary.vendor_id})?[0].id
                  onCheckedStatusChanged: @handlerCheckedChange
                  onVendorChanged: @handlerVendorChange
            ]
          ]
          div {className: 'panel'}, [
            div {className: 'button-bar'}, [
              ul {className: 'button-group'}, [
                li {}, input {type: 'button', className: 'button tiny', value: '按照装箱数四舍五入'}, ''
                li {}, input {type: 'button', className: 'button tiny', value: '按照装箱数向上'}, ''
                li {}, input {type: 'button', className: 'button tiny', value: '按照装箱数向下'}, ''
                li {}, input {type: 'button', className: 'button tiny success', value: '生成采购单'}, ''
              ]
            ]
          ]
        ]

  .factory '$peItem', ($filter, $label) ->
    {tr, td, input, select, option, span} = React.DOM
    React.createClass
      handlerCheckedChange: (e) ->
        @props.onCheckedStatusChanged(@props.detail.id, e.currentTarget.checked)
      handlerVendorChange: (e) ->
        @props.onVendorChanged(@props.detail.id, e.currentTarget.value)
      render: ->
        tr {}, [
          td {}, [
            input {type: 'checkbox', checked: @props.chekcing, onChange: @handlerCheckedChange}
          ]
          td {}, select {defaultValue: @props.selected, onChange: @handlerVendorChange}, [
            @props.detail.item.quotations.map (q) =>
              option {value: q.id}, "#{q.vendor.abbreviation}(#{q.vendor.code})"
          ]
          td {}, $label {id: @props.detail.item_id, key: 'itemlist', field: 'sku'}
          td {}, $label {id: @props.detail.warehouse_id, key: 'whlist'}
          td {}, @props.detail.transportation
          td {}, @props.detail.request_qty
          td {}, ($filter('filter') @props.detail.item.quotations, {id: @props.selected})?[0].spq
          td {}, input {type: 'text'}, ''
          td {}, input {type: 'text'}, ''
          td {}, ($filter('filter') @props.detail.item.quotations, {id: @props.selected})?[0].tax_rate
          td {}, $filter('currency') ($filter('filter') @props.detail.item.quotations, {id: @props.selected})?[0].unit_price
          td {}, @props.detail._quotation?.unit_price * @props.detail._qty
          td {}, ($filter('filter') @props.detail.item.quotations, {id: @props.selected})?[0].vendor.payment_period
        ]
