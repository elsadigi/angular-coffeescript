'use strict'

###*
 # @ngdoc object
 # @name tableExample.controller:TabsCtrl

 # @description

###
class TabsCtrl
  ### @ngInject ###
  constructor:(
    $state
    $scope
  ) ->
    @currentTab = $state.current.data.selectedTab

    $scope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) =>
      @currentTab = toState.data.selectedTab


angular
.module('tableExample')
.controller 'TabsCtrl', TabsCtrl
