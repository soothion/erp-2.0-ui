'use strict'

describe 'Filter: fee', () ->

  # load the filter's module
  beforeEach module 'laravelUiApp'

  # initialize a new instance of the filter before each test
  fee = {}
  beforeEach inject ($filter) ->
    fee = $filter 'fee'

  it 'should return the input prefixed with "fee filter:"', () ->
    text = 'angularjs'
    expect(fee text).toBe ('fee filter: ' + text)
