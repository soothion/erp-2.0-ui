'use strict'

angular.module('laravelUiApp')
  .directive('react', () ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text 'this is the react directive'
  )

  .factory '$label', ($filter, $meta) ->
    {span} = React.DOM
    React.createClass
      getInitialState: ->
        label: @props.id
      componentWillMount: ->
        $meta(@props.key).$promise.then (result) =>
          field = @props.field || 'name'
          console.log @props.id
          console.log @props.key
          @setState {label: ($filter('filter') result, {id: parseInt @props.id}, true)[0]?[field] || @props.id}
      render: ->
        span {}, @state.label