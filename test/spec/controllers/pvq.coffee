'use strict'

describe 'Controller: PvqCtrl', () ->

  # load the controller's module
  beforeEach module 'laravelUiApp'

  PvqCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PvqCtrl = $controller 'PvqCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
