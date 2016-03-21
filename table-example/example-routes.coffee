'use strict'

angular
  .module 'tableExample'
  .config ($stateProvider) ->
    $stateProvider
      .state 'examples',
        url: '/examples'
        templateUrl: 'table-example/views/examples.tpl.html'
        controller: 'TabsCtrl'
        controllerAs: 'tabsCtrl'
        deepStateRedirect: { default: { state: 'examples.overview' } },

      .state 'examples.overview',
        url: '/overview'
        data:
          'selectedTab': 0
        views:
          'examples@examples':
            controller: 'DataTableCtrl'
            controllerAs: 'listCtrl'
            resolve:
              entityManager: (exampleManager) ->
                exampleManager
              pageTitle: ->
                'Examples'
              pageDescription: ->
                'example description'
              deleteBoxTitle: ->
                'Delete example'
              deleteBoxBody: ->
                'delete this example?'
              AddBoxTitle: ->
                'add example'
              editBoxTitle: ->
                'edit example'
              loadFilterParams: ->
                {}