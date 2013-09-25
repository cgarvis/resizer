'use strict'

describe 'Factory: GCD', () ->
  # load the controller's module
  beforeEach module 'resizer'

  gcd = ->

  beforeEach inject (_gcd_) ->
    gcd = _gcd_

  it 'finds the greatest common denominator for 4 and 8', ->
    expect(gcd(4,8)).toBe 4

  it 'finds the greatest common denominator for 8 and 4', ->
    expect(gcd(8,4)).toBe 2

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
