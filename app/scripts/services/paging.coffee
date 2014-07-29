'use strict'

angular.module('laravelUiApp').factory 'factoryPaging', ->
  return (func, size) ->
    result = {
      curPage: 1
      data: {}

      hasNextPage: ->
        return this.data.length == size + 1

      hasPrePage: ->
        return this.curPage > 1

      goNextPage: ->
        this.curPage += 1
        return this.fetch()

      goPrePage: ->
        this.curPage -= 1
        return this.fetch()

      first: ->
        this.curPage = 1
        return this.fetch()

      fetch: ->
        this.data = func(this.curPage, size)
        return this.data.slice if (this.hasNextPage())
        return this.data
    }

    result.fetch()
    return result