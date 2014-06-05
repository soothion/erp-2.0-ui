'use strict'

angular.module('laravelUiApp')
  .directive('whList', (Meta) ->
    
    {div, label, select, option, span} = React.DOM

    WHLIST = React.createClass
      getInitialState: ->
        {
          value: ''
          options: []
          error: false
        }

      componentWillMount: ->
        Meta.cache('/api/item/meta/warehouseList').query (rtn) =>
          this.setState {options: rtn}

      render: ->
        scope = this.props.scope

        div {className: 'form-group'}, [
          (label {className: 'control-label'}, '目的仓')
          (select {className: 'form-control', ref: 'wh', required: this.props.required, value: this.state.value, onChange: (e) => 
            e.preventDefault()
            this.setState {value : this.refs.wh.getDOMNode().value}
          }, [
            this.state.options.map (op) ->
              (option {value: op.id}, op.name)
          ])
          (span {className: 'help-inline'}, 'Required')
        ]

    directive = 
      template: '<div></div>'
      restrict: 'E'
      scope: {
        value: ' &'
      }
      require: '?ngModel'
      link: (scope, element, attrs) ->
        React.renderComponent (WHLIST {
          scope: scope
        }), element[0]
        scope.$on('$destroy', ->
          React.unmountComponentAtNode element[0])
  )

# <select name="warehouse_id" ng-model="request.warehouse_id" class="form-control" required ng-options="wh.id as wh.name for wh in whs" ng-disabled="request.status!='pending'"></select>
  # <div class="form-group" ng-class="{'has-error': editForm.warehouse_id.$invalid}">
  #                 <label class="control-label">目的仓</label>
  #                 <select name="warehouse_id" ng-model="request.warehouse_id" class="form-control" required ng-options="wh.id as wh.name for wh in whs" ng-disabled="request.status!='pending'"></select>
  #                 <span ng-show="editForm.warehouse_id.$error.required" class="help-inline">Required</span>
  #               </div>