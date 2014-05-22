'use strict'

describe 'Controller: PreCtrl', () ->

  # load the controller's module
  beforeEach module 'laravelUiApp'

  PreCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PreCtrl = $controller 'PreCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
