'use strict'

describe 'Directive: batchUpload', () ->

  # load the directive's module
  beforeEach module 'laravelUiApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<batch-upload></batch-upload>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the batchUpload directive'
