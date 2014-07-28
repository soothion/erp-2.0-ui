'use strict'

describe 'Controller: PvCtrl', () ->

  # load the controller's module
  beforeEach module 'laravelUiApp'

  PvCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PvCtrl = $controller 'PvCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
