'use strict'

{div} = React.DOM

Hello = React.createClass
  render: ->
    (div {className: 'well'}, ['Hello ' + @props.name])

angular.module('laravelUiApp')
  .directive('datePicker', () ->
    restrict: 'E'
    link: (scope, element, attrs) ->
      React.renderComponent (Hello {name: attrs.name}), element[0]
  )
