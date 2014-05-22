'use strict'

describe 'Controller: PrCtrl', () ->

  # load the controller's module
  beforeEach module 'laravelUiApp'

  PrCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrCtrl = $controller 'PrCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
