'use strict'

angular.module('laravelUiApp')
  .directive('whList', (Meta) ->
    # FIXME: 目前还不支持界面对数据的反向绑定，也许这部分全部交给React来处理？
    
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

        div {className: 'form-group'}, [
          (label {className: 'control-label'}, '目的仓')
          (label {}, this.state.value)
          (select {className: 'form-control', ref: 'wh', required: this.props.required, value: this.state.value, onChange: (e) => 
            this.setState {value : this.refs.wh.getDOMNode().value}
            e.preventDefault()
          }, [
            this.state.options.map (op) ->
              (option {value: op.id}, op.name)
          ])
          (span {className: 'help-inline'}, 'Required')
        ]

    directive = 
      restrict: 'E'
      scope: {
        selected: '=ngModel'
      }
      require: '?ngModel'
      link: (scope, element, attrs) ->
        c = React.renderComponent (WHLIST {value: scope.selected}), element[0]
        scope.$watch 'selected', ->
          c.setState {value: scope.selected}
        scope.$on '$destroy', ->
          React.unmountComponentAtNode element[0]
  )

# <select name="warehouse_id" ng-model="request.warehouse_id" class="form-control" required ng-options="wh.id as wh.name for wh in whs" ng-disabled="request.status!='pending'"></select>
  # <div class="form-group" ng-class="{'has-error': editForm.warehouse_id.$invalid}">
  #                 <label class="control-label">目的仓</label>
  #                 <select name="warehouse_id" ng-model="request.warehouse_id" class="form-control" required ng-options="wh.id as wh.name for wh in whs" ng-disabled="request.status!='pending'"></select>
  #                 <span ng-show="editForm.warehouse_id.$error.required" class="help-inline">Required</span>
  #               </div>