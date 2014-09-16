'use strict'

angular.module('laravelUiApp')
  .directive('prAllot', ($prAllotTable, Meta) ->
    restrict: 'A'
    scope:
      'plan_id': '=planId'
      'item_id': '=itemId'
      'wh_id': '=whId'
      'trans': '='
      'qty': '=ngModel'
    link: (scope, element, attrs) ->
      
      Clazz = Meta.store("/api/purchase/plan-detail/#{scope.plan_id}/#{scope.item_id}/#{scope.wh_id}/#{scope.trans}")

      element.after '<div />'
      holder = element.next()[0]
      watches = []

      element.bind 'focus', ->
        Clazz.query (details) ->
          component = React.renderComponent ($prAllotTable {details: details, qty: 0}), holder
          watches.push scope.$watch 'qty', ->
            component.setState {qty: scope.qty}

      element.bind 'blur', ->
        watch() for watch in watches
        React.unmountComponentAtNode holder

      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder
  )
  .factory '$prAllotTable', ($filter, $label) ->
    {table, thead, tbody, tr, td, th} = React.DOM
    React.createClass
      getInitialState: ->
        qty: @props.qty
      componentWillMount: ->
        ''
      render: ->
        table {width: '100%'}, [
          thead {}, [
            tr {}, [
              th {}, '渠道'
              th {}, '原始需求'
              th {}, '所占比例'
              th {}, '预计分配'
            ]
          ]
          tbody {}, [
            @props.details.map (d) =>
              tr {}, [
                td {}, $label {key: 'platformlist', id: d.platform_id, field: 'abbreviation'}
                td {}, d.qty
                td {}, d.pivot.percent
                td {}, $filter('number') (d.pivot.percent * parseInt @state.qty), 0
              ]
          ]
        ]
