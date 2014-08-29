'use strict'

describe 'Directive: exportButton', () ->

  # load the directive's module
  beforeEach module 'laravelUiApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<export-button></export-button>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the exportButton directive'
