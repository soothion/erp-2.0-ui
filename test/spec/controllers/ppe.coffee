'use strict'

describe 'Controller: PpeCtrl', () ->

  # load the controller's module
  beforeEach module 'laravelUiApp'

  PpeCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PpeCtrl = $controller 'PpeCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
