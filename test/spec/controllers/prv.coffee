'use strict'

describe 'Controller: PrvCtrl', () ->

  # load the controller's module
  beforeEach module 'laravelUiApp'

  PrvCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    PrvCtrl = $controller 'PrvCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
