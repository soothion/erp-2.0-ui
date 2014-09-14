'use strict'

angular.module('laravelUiApp')
  .directive('purchaseExec', ($pe) ->
    restrict: 'A'
    scope:
      'details': '=ngModel'
    link: (scope, element, attrs) ->
      element.after '<div />'
      holder = element.next()[0]
      component = React.renderComponent ($pe {details: scope.details}), holder
      scope.$watch 'details', ->
        component.setState {details: scope.details}
      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder

  )
  .factory '$pe', ($peItemList) ->
    {table, thead, tbody, tr, th, td, input} = React.DOM
    React.createClass
      getInitialState: ->
        details: @props.details
        checked: false
      handlerCheckAll: (e) ->
        @setState {checked: e.currentTarget.checked}
      render: ->
        table {width: '100%'}, [
          thead {}, [
            tr {}, [
              th {}, [
                input {type: 'checkbox', onChange: @handlerCheckAll}, ''
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
          $peItemList {data: @state.details, checked: @state.checked}
        ]

  .factory '$peItemList', ($peItem) ->
    {tbody} = React.DOM
    React.createClass
      render: ->
        tbody {} ,[
          if @props.data then @props.data.map (i) =>
            $peItem {item: i, checked: @props.checked}
        ]

  .factory '$peItem', ($filter) ->
    {tr, td, input, span} = React.DOM
    React.createClass
      getInitialState: ->
        checked: @props.checked
      handlerCheckeChange: (e) ->
        e.preventDefault()
        console.log e.currentTarget.checked
      render: ->
        tr {}, [
          td {}, [
            input {type: 'checkbox', checked: @state.checked}
            span {}, @state.checked + '111'
          ]
          td {}, $filter('vendor') @props.item._vendor.name
          td {}, $filter('item') @props.item.item_id
          td {}, $filter('warehouse') @props.item.warehouse_id
          td {}, @props.item.transportation
          td {}, @props.item.request_qty
          td {}, @props.item.spq
          td {}, ''
          td {}, '' 
          td {}, @props.item.tax
          td {}, @props.item.price
          td {}, @props.item.total
          td {}, @props.item.lt
        ]
