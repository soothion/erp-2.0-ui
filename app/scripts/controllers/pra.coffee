'use strict'

angular.module('laravelUiApp')
  .controller 'PraCtrl', ($scope, $modal, Meta) ->

    store = Meta.store '/api/audit/pr/:id', {id: '@id'}, {approve: {method: 'PUT', isArray:true, params: {action: 'approve'}}, reject: {method: 'PUT', isArray:true, params: {action: 'reject'}}}

    $scope.load = ->
      store.query (rtn) ->
        $scope.requests = rtn

    $scope.load()

    $scope.showDetail = (id, type) ->
      store.get {id: id}, (rtn) ->
        $scope.request = rtn
        modalInstance = $modal.open {
          templateUrl: 'views/pra-detail.html'
          controller: ['$scope', '$modalInstance', 'request', ($scope, $modalInstance, request) =>
            $scope.request = request

            $scope.pass = ->
              store.approve {
                id: request.id
                note: request.verified_note
              }, ->
                $modalInstance.close $scope.request

            $scope.reject = ->
              store.reject {
                id: request.id
                note: request.verified_note
              }, ->
                $modalInstance.close $scope.request

            $scope.cancel = ->
              $modalInstance.dismiss 'cancel'
          ]
          resolve: {
            request: ->
              $scope.request
          }
        }

        modalInstance.result.then (request) ->
          $scope.load()
        , () ->
          console.log 'cancelled'