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

      element.bind 'focus', ->
        component = React.renderComponent ($prAllotTable {details: [], qty: 0}), holder
        scope.$watch 'qty', ->
          component.setState {qty: scope.qty}
        Clazz.query (rtn) ->
          component.setState {details: rtn}

      element.bind 'blur', ->
        React.unmountComponentAtNode holder

      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder
  )
  .factory '$prAllotTable', ($filter) ->
    {table, tr, td, th} = React.DOM
    React.createClass
      getInitialState: ->
        details: @props.details
        qty: @props.qty
      componentWillMount: ->
        ''
      render: ->
        table {width: '100%'}, [
          tr {}, [
            th {}, '渠道'
            th {}, '原始需求'
            th {}, '所占比例'
            th {}, '预计分配'
          ]
          @state.details.map (d) =>
            tr {}, [
              td {}, $filter('platform') d.platform_id
              td {}, d.qty
              td {}, d.pivot.percent
              td {}, d.pivot.percent * parseInt @state.qty
            ]
        ]
