'use strict'

describe 'Controller: PpCtrl', () ->

  # load the controller's module
  beforeEach module 'laravelUiApp'

  PpCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PpCtrl = $controller 'PpCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
