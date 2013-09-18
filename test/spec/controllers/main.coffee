'use strict'

describe 'Controller: MainCtrl', () ->

  # load the controller's module
  beforeEach module 'resizer'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope
    }

  it 'defaults height to 100', () ->
    expect(scope.resize.height).toBe '100'

  it 'defaults width to 100', () ->
    expect(scope.resize.height).toBe '100'
