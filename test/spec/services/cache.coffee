'use strict'

describe 'Service: Cache', () ->

  # load the service's module
  beforeEach module 'laravelUiApp'

  # instantiate service
  Cache = {}
  beforeEach inject (_Cache_) ->
    Cache = _Cache_

  it 'should do something', () ->
    expect(!!Cache).toBe true
