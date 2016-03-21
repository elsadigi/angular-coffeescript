'use strict'

###*
 # @ngdoc service
 # @name mundoComponents.factory:MundoDefaultManager

 # @description

###
angular
  .module 'dataTableBaseComponents'
  .factory 'defaultManager',(
    Restangular
    $log
    _
    RestUtils
    TemplateUtils
  ) ->
    MundoDefaultManagerBase = ->
      {
        conf: {
          url: ''
          newForm: []
          newObject: []
          updateForm: []
          updateObject: []
          autoTenant:false
          searchFields:[]
          extraActions:[]
          tableActions:[]
          extraObjects:[]
          extraForms:[]
          listSchema: [
            key: 'id'
            title: 'id'
            sort: 'id'
          ]
          actions: ['create', 'update', 'delete', 'print', 'list', 'search']
        }

        transport: Restangular

        defaultQuery: {
          sort: 'id'
          limit: 10
          page: 1
          search:
            query: ''
            active: false
            options:
              debounce: 500
        }

        getDetailTemplateUrl: ->
          TemplateUtils.getMundoDataDetailTemplateUrlString()

        getList: (query = @defaultQuery) ->
          params =
            offset: 0
            limit: 10
            sort: 'updatedAt'

          params.offset = query.limit * query.page - query.limit
          params.limit = query.limit
          $log.debug 'query:', query
          $log.debug 'url:', @getUrl()
          if query.sort
            if query.sort.substr(0,1) == "-"
              params.sort = query.sort.substr(1) + ',DESC'
            else
              params.sort = query.sort.substr(0) + ',ASC'

          if query.search && query.search.active
            searchString = ''
            searchFields =  @getSearchFields()
            _.each searchFields, (field) ->
              searchString = "#{searchString},#{field},like #{query.search.query}"

            params['filter[]'] = "OR#{searchString}"

          @transport.all(@getUrl()).getList(params)

        getListWithParams: (params) ->
          @transport.all(@getUrl()).getList(params)

        getFullList: (params) ->
          RestUtils.getFullList @transport.all(@getUrl()), params

        new: (data) ->
          @transport.all(@getUrl()).post(_.pick(data, @getNewObject()), {}, autoTenant: @conf.autoTenant)

        update: (id, data) ->
          @transport.all(@getUrl()).one(id).customPUT(_.pick(data, @getUpdateObject()))

        one: (id) ->
          @transport.one(@getUrl(), id).get()

        delete: (id) ->
          @transport.one(@getUrl(), id).remove()

        submit: (data, entity) ->
          if entity
            @update(entity.id, data)
          else
            @new(data)

        setUrl: (url) ->
          @conf.url = url

        getUrl: ->
          if @conf.url.length > 0
            @conf.url
          else
            $log.debug "api url is missing, use .setUrl() to set it"

        setNewObject: (obj) ->
          @conf.newObject = obj

        setUpdateObject: (obj) ->
          @conf.updateObject = obj

        setObject: (type, obj)->
          @conf.extraObjects[type] = obj

        getObject: (type)->
          if @conf.extraObjects[type]
            @conf.extraObjects[type]
          else
            @conf.extraObjects['default']


        setSearchFields: (fields) ->
          @conf.searchFields = fields

        setActions:(actions)->
          @conf.actions = actions

        getActions: ->
          @conf.actions

        getSearchFields: () ->
          @conf.searchFields

        getListSchema: ->
          @conf.listSchema

        getNewForm: ->
          []

        getEditForm : (data) ->
          []

        getForm : (data) ->
          if data
            form = @getEditForm(data)
            if form.length > 0
              form
            else
              @getNewForm()
          else
            @getNewForm()

        getNewObject: ->
          @conf.newObject

        getUpdateObject: ->
          if(@conf.updateObject.length > 0)
            @conf.updateObject
          else
            @conf.newObject

        addExtraAction:(action) ->
          @conf.extraActions = @conf.extraActions.concat action

        getExtraActions: ->
          @conf.extraActions

        addTableAction:(action) ->
          @conf.tableActions = @conf.tableActions.concat action

        getTableActions: ->
          @conf.tableActions

        extractIds: (data) ->
          if data
            idArray = []
            for item in data
              idArray.push(item.id)

            idArray

        getExtraFormByType: (type) ->
          if @conf.extraForms[type]
            @conf.extraForms[type]
          else
            @conf.extraForms['default']

        setExtraForm: (type, form) ->
          @conf.extraForms[type] = form

        setAutoTenant: () ->
          @conf.autoTenant = true
    }


    MundoDefaultManagerBase
