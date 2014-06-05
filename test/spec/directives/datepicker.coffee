'use strict'

describe 'Directive: datePicker', () ->

  # load the directive's module
  beforeEach module 'laravelUiApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<date-picker></date-picker>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the datePicker directive'
