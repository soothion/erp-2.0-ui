'use strict'

angular.module('laravelUiApp')
  .directive('prView', ($compile, $timeout, $purchaseRequestView, Meta) ->
    scope: {
      "rid": '='
    }
    restrict: 'A'
    link: (scope, element, attrs) ->
      Master = Meta.store('/api/purchase/request/:id', {id: '@id'})
      Detail = Meta.store '/api/purchase/requestDetail/:id', {id: '@id'}, {update: {method: 'PUT'}}

      element.after '<div class="reveal-modal" data-reveal />'
      holder = element.next()[0]

      element.bind 'click', ->
        component = React.renderComponent ($purchaseRequestView {rid: scope.rid}), holder
        Master.get {id: scope.rid}, (rtn) =>
          component.setState {master: rtn}
        Detail.query {rid: scope.rid}, (rtn) =>
          component.setState {details: rtn}
        $(holder).foundation 'reveal', 'open'

        scope.$watch 'rid', ->
          component.setState {rid: scope.rid}

      $(document).on 'closed.fndtn.reveal', '[data-reveal]', ->
        React.unmountComponentAtNode holder

      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder
  )
  .factory '$purchaseRequestView', ($filter) ->
    {div, label, select, option, span, h5, table, tr, td, a} = React.DOM
    React.createClass
      getInitialState: ->
        id: @props.rid
        master: {}
        details: []
      componentWillMount: ->
        ''
      render: ->
        div {}, [
          h5 {}, '申购单详情查看'
          table {width: '100%'}, [
            tr {}, [
              td {className: 'title'}, '申购单编号'
              td {className: ''}, @state.master.invoice
              td {className: 'title'}, '类型'
              td {className: ''}, @state.master.type
              td {className: 'title'}, '目的仓'
              td {className: ''}, $filter('warehouse') @state.master.warehouse_id
            ]
            tr {}, [
              td {className: 'title'}, '关联ID'
              td {className: ''}, @state.master.relation_id
              td {className: 'title'}, '状态'
              td {className: ''}, @state.master.status
              td {className: 'title'}, '提单人'
              td {className: ''}, $filter('agent') @state.master.agent
            ]
            tr {}, [
              td {className: 'title'}, '创建时间'
              td {className: ''}, @state.master.created_at
              td {className: 'title'}, '修改时间'
              td {className: 'title'}, @state.master.updated_at
              td {className: 'title'}, '审核过期时间'
              td {className: ''}, @state.master.updated_at
            ]
            tr {}, [
              td {className: 'title'}, '备注'
              td {className: '', colSpan: 5}, @state.master.note
            ]
          ]
          @state.details.map (d) =>
            table {width: '100%'}, [
              tr {}, [
                td {className: 'title'}, 'SKU'
                td {className: ''}, d.item.sku
                td {className: 'title'}, 'SKU描述'
                td {className: ''}, d.item.description
                td {className: 'title'}, '渠道'
                td {className: ''}, [
                  span {className: 'label success'}, d.platform.name
                ]
              ]
              tr {}, [
                td {className: 'title'}, '数量'
                td {className: ''}, d.qty
                td {className: 'title'}, 'ETA'
                td {className: ''}, d.end_date
                td {className: 'title'}, '估算运费'
                td {className: ''}, ($filter('filter') d.item.cost, {warehouse_id: @state.master.warehouse_id})[0]
              ]
              tr {}, [
                td {className: 'title'}, 'SPQ'
                td {className: ''}, d.item.spq.spq
                td {className: 'title'}, '运输方式'
                td {className: ''}, d.transportation
                td {className: 'title'}, '备注'
                td {className: ''}, d.note
              ]
              tr {}, [
                td {className: 'title'}, '实际分配数量'
                td {className: ''}, d.distribute_qty || 0
                td {className: 'title'}, '创建日期'
                td {className: ''}, d.created_at
                td {className: 'title'}, '修改日期'
                td {className: ''}, d.updated_at
              ]
            ]
          a {className: 'close-reveal-modal', onClick: (e) =>
            this.setState {css: 'close'}
          }, "×"
        ]
