'use strict'

describe 'Directive: prView', () ->

  # load the directive's module
  beforeEach module 'laravelUiApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<pr-view></pr-view>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the prView directive'
