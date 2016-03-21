'use strict'

class Teaser
  constructor: ->
    return {
      restrict: 'AE'
      scope: {}
      template: '<ng-include src="templateUrl"/>'
      replace: false
      bindToController: {
        entity:'='
        type:'='
        templateOptions:'='
      }
      controllerAs: 'teaser'
      controller: ->
      link: (scope, element, attrs) ->
        ###jshint unused:false ###
        ###eslint "no-unused-vars": [2, {"args": "none"}]###

##      default template folder
        templateFolder = 'default/template/folder'
        if scope.teaser.templateOptions?.folder
          templateFolder = scope.teaser.templateOptions.folder

        scope.templateUrl = "#{templateFolder}/#{scope.teaser.type}.tpl.html"
    }

angular
  .module 'example'
  .directive 'teaser', Teaser
