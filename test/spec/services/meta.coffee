'use strict'

describe 'Service: Meta', () ->

  # load the service's module
  beforeEach module 'laravelUiApp'

  # instantiate service
  Meta = {}
  beforeEach inject (_Meta_) ->
    Meta = _Meta_

  it 'should do something', () ->
    expect(!!Meta).toBe true
