'use strict'

describe 'Directive: itemView', () ->

  # load the directive's module
  beforeEach module 'laravelUiApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<item-view></item-view>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the itemView directive'
