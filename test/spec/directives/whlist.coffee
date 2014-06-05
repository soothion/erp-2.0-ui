'use strict'

describe 'Directive: whList', () ->

  # load the directive's module
  beforeEach module 'laravelUiApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<wh-list></wh-list>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the whList directive'
