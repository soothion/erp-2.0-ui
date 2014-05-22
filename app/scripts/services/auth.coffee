'use strict'

angular.module('laravelUiApp')
  .factory 'Auth', ($resource, $sanitize, Cache, Message) ->

    sanitizeCredentials = (credentials) ->
      {
        username: $sanitize(credentials.username)
        password: $sanitize(credentials.password)
        remember: $sanitize(credentials.remember)
        _token: CSRF_TOKEN
      }

    # Public API here
    {
      logout: (callback) ->
        Cache.unset 'auth.user'
        Cache.unset 'authenticated'
        callback()

      isLoggedIn: ->
        Cache.get 'authenticated'

      login: (credentials, success) ->
        $resource('/apilogin', {}, {login: {method: 'post'}, logout: {method: 'get'}}).login credentials, (rtn) ->
          Cache.set 'auth.user', rtn
          Cache.set 'authenticated', true
          Message.clear()
          success()
    }
