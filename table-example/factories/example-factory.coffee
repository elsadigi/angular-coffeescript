'use strict'

###*
 # @ngdoc service
 # @name tableExample.factory:exampleManager

 # @description

###
angular
  .module 'tableExample'
  .factory 'exampleManager',(
    Restangular
    defaultManager
  ) ->
    ExampleBase =  new defaultManager()

    ExampleBase.setUrl('examples')
    ExampleBase.setNewObject(['field_one', 'field_two', 'field_three'])
    ExampleBase.setUpdateObject(['field_one', 'field_two', 'field_three'])
    ExampleBase.setSearchFields(['field_one', 'field_two', 'field_three'])

    ExampleBase.getNewForm = ->
      [
        key: 'field_one'
        name: 'field_one'
        type: 'input'
        templateOptions:
          label: 'Field one'
          placeholder: 'Field one'
          required: true
          description: 'Field one'
      ,
        key: 'field_two'
        name: 'field_two'
        type: 'input'
        templateOptions:
          label: 'Field two'
          placeholder: 'Field two'
          required: true
          description: 'Field two'
      ,
        key: 'field_three'
        name: 'field_three'
        type: 'input'
        templateOptions:
          label: 'Field Three'
          placeholder: 'Field three'
          required: true
          description: 'Field three'
      ]

    ExampleBase.getEditForm = (data)->
      [
        key: 'field_one'
        name: 'field_one'
        type: 'input'
        defaultValue: data.field_one,
        templateOptions:
          label: 'Field one'
          placeholder: 'Field one'
          required: true
          description: 'Field one'
      ,
        key: 'field_two'
        name: 'field_two'
        type: 'input'
        defaultValue: data.field_two,
        templateOptions:
          label: 'Field two'
          placeholder: 'Field two'
          required: true
          description: 'Field two'
      ,
        key: 'field_three'
        name: 'field_three'
        type: 'input'
        defaultValue: data.field_three,
        templateOptions:
          label: 'Field Three'
          placeholder: 'Field three'
          required: true
          description: 'Field three'
      ]

    ExampleBase.getListSchema = ->
      [
        key: 'field_one'
        title: 'Field one'
        sort: 'field_one'
      ,
        key: 'field_two'
        title: 'Field two'
        sort: 'field_two'
      ,
        key: 'field_three'
        title: 'Field three'
        sort: 'field_three'
      ]

    ExampleBase
