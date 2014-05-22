'use strict'

describe 'Service: Message', () ->

  # load the service's module
  beforeEach module 'laravelUiApp'

  # instantiate service
  Message = {}
  beforeEach inject (_Message_) ->
    Message = _Message_

  it 'should do something', () ->
    expect(!!Message).toBe true
