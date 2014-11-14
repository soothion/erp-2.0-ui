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

      element.after '<div class="reveal-modal" data-reveal>loading...</div>'
      holder = element.next()[0]

      scope.master = scope.details = []

      element.bind 'click', ->
        Master.get {id: scope.rid}, (master) =>
          scope.master = master
          Detail.query {rid: scope.rid}, (details) =>
            scope.details = details
            component = React.renderComponent ($purchaseRequestView {master: scope.master, details: scope.details}), holder
        $(holder).foundation 'reveal', 'open'

      $(document).on 'closed.fndtn.reveal', '[data-reveal]', ->
        React.unmountComponentAtNode holder

      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder
  )
  .factory '$purchaseRequestView', ($filter, $label) ->
    {div, select, option, span, h5, table, tr, td, th, a, b} = React.DOM
    React.createClass
      render: ->
        div {}, [
          h5 {}, '申购单详情查看'
          table {width: '100%'}, [
            tr {}, [
              td {className: 'title'}, '申购单编号'
              td {className: ''}, @props.master.invoice
              td {className: 'title'}, '类型'
              td {className: ''}, @props.master.type
              td {className: 'title'}, '目的仓'
              td {className: ''}, $label({key: 'whlist', id: @props.master.warehouse_id})
            ]
            tr {}, [
              td {className: 'title'}, '关联ID'
              td {className: ''}, @props.master.relation_id
              td {className: 'title'}, '状态'
              td {className: ''}, @props.master.status
              td {className: 'title'}, '提单人'
              td {className: ''}, $label {id: @props.master.agent, key: 'userlist'}
            ]
            tr {}, [
              td {className: 'title'}, '创建时间'
              td {className: ''}, @props.master.created_at
              td {className: 'title'}, '修改时间'
              td {className: 'title'}, @props.master.updated_at
              td {className: 'title'}, '审核过期时间'
              td {className: ''}, @props.master.updated_at
            ]
            tr {}, [
              td {className: 'title'}, '备注'
              td {className: '', colSpan: 3}, @props.master.note
              td {className: 'title'}, '渠道'
              td {className: ''}, [
                span {className: 'label success'}, @props.master.platform
              ]
            ]
          ]
          table {width: '100%'}, [
            tr {}, [
              th {className: 'title'}, 'SKU'
              # th {className: 'title'}, '描述'
              # th {className: 'title'}, '渠道'
              th {className: 'title'}, '需求'
              th {className: 'title'}, '分配'
              th {className: 'title'}, 'ETA'
              th {className: 'title'}, '运费'
              th {className: 'title'}, 'SPQ'
              th {className: 'title'}, '运输'
              th {className: 'title'}, '备注'
              # th {className: 'title'}, '创建日期'
              # th {className: 'title'}, '修改日期'
            ]
            @props.details.map (d) =>
              tr {}, [
                td {className: ''}, d.item.sku
                # td {className: ''}, d.item.description
                # td {className: ''}, [
                #   span {className: 'label success'}, d.platform.name
                # ]
                td {className: ''}, d.qty
                td {className: ''}, d.distribute_qty || 0
                td {className: ''}, d.end_date
                td {className: ''}, [
                    b {}, $filter('fee') d.item, @props.master.warehouse_id, 'sea'
                    '/'
                    b {}, $filter('fee') d.item, @props.master.warehouse_id, 'air'
                  ]
                td {className: ''}, d.item.spq?.spq
                td {className: ''}, d.transportation
                td {className: ''}, d.note
                # td {className: ''}, d.created_at
                # td {className: ''}, d.updated_at
              ]
          ]
          a {className: 'close-reveal-modal'}, "×"
        ]
