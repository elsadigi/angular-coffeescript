'use strict'

###*
 # @ngdoc object
 # @name dataTableBaseComponents.controller:DataTableCtrl

 # @description

###
class DataTableCtrl
  ### @ngInject ###
  constructor: (
    entityManager
    pageTitle
    pageDescription
    deleteBoxTitle
    deleteBoxBody
    AddBoxTitle
    editBoxTitle
    loadFilterParams
    $log
    $mdDialog
    FormDialog
    ConfirmBox
    $q
    $filter
    $sce
    _
  ) ->
    init = () =>

      @items = []
      @user = {}
      @selected = []
      @pageTitle = pageTitle
      @pageDescription = pageDescription
      @loadFilterParams = loadFilterParams
      @query = entityManager.defaultQuery
      @schema = entityManager.getListSchema()
      @detailTemplate = entityManager.getDetailTemplateUrl()
      @extraActions = entityManager.getExtraActions()
      @tableActions = entityManager.getTableActions()
      @showInlineDetail = showInlineDetail
      @getDetailTemplate = getDetailTemplate


      @load = load
      @onPaginate = onPaginate
      @onReorder = onReorder

      @openSearch = openSearch
      @closeSearch = closeSearch

      @openAddDialog = openAddDialog
      @openEditDialog = openEditDialog
      @deleteSelected = deleteSelected
      @deleteSingle = deleteSingle

      @getCsvContent = getCsvContent
      @getCsvHeader = getCsvHeader

      @getValue = getValue
      @isDefined = isDefined

      @isEditable = checkAction('update')
      @isDeletable = checkAction('delete')
      @isCreatable = checkAction('create')
      @isPrintable = checkAction('print')
      @isSearchable = checkAction('search') && entityManager.conf.searchFields.length > 0

    ###########

#   list
    load = (query = @query) =>
      @selected = []
      @promise = entityManager.getList(query, @loadFilterParams)
        .then (data) =>
          @items = data

    onPaginate = (page, limit) =>
      @load(angular.extend({}, @query, {page: page, limit: limit}))

    onReorder = (order) =>
      @load(angular.extend({}, @query, {sort: order}))

#   search

    openSearch = =>
      @query.search.active = true

    closeSearch= =>
      @query.search.active = false
      @query.search.query = ''
      @load()

#   CRUD
    openAddDialog = =>
      FormDialog.showFormDialog(AddBoxTitle, entityManager)
      .then =>
        @load()

    openEditDialog = (item) =>
      FormDialog.showFormDialog(editBoxTitle, entityManager, item)
      .then () =>
        @load()

    deleteSelected = =>
      ConfirmBox.showConfirmDialog(deleteBoxTitle, deleteBoxBody)
      .then =>
        removeSelected(@selected)
        .then =>
          @load()

    deleteSingle = (id) ->
      ConfirmBox.showConfirmDialog(deleteBoxTitle, deleteBoxBody)
      .then =>
        removeSingle(id)
        .then =>
          @load()

    removeSelected = (selected) ->
      $q.all _.map selected, (item) ->
        removeSingle(item.id)

    removeSingle = (id) ->
      entityManager.delete(id)

#   print
    getCsvContent = =>
      content = []
      for sItem in @selected
        obj = {}
        for item in @schema
          $log.debug item
          obj[item.key] = @getValue(sItem, item.key, @isDefined(item.multiple), item.type)
        content.push(obj)
      content

    getCsvHeader = =>
      item.title for item in @schema

#   helper
    getValue = (row, path, multiple = false, type = null) ->
      if multiple isnt false
        getVals(row, path.split('.'), multiple, type)
      else
        getVal(row, path.split('.'), type)

    isDefined = (s) ->
      if s?
        s

    checkAction = (action) ->
      action in entityManager.conf.actions

    getVal = (row, keys, type = null) ->
      if row == "none"
        row
      else
        currentKey = keys.shift()
        currentVal = if currentKey of row then row[currentKey] else 'none'
        if keys.length == 0
          switch type
            when 'dateTime' then $filter('date')(currentVal, 'dd/MM/yyyy HH:mm:ss')
            when 'date' then $filter('date')(currentVal, 'dd/MM/yyyy')
            when 'boolean' then  setBooleanIconForValue currentVal
            when 'color' then setColorValue currentVal
            else currentVal
        else
          getVal(currentVal, keys, type)

    setColorValue = (currentVal) ->
      upperCaseColor = $filter('uppercase')(currentVal)
      colorDiv = '<div style="background-color:#' + currentVal + '" class="color-box"></div>'
      $sce.trustAsHtml(colorDiv + upperCaseColor)

    setBooleanIconForValue = (currentVal) ->
      icon = ''
      color = ''
      switch currentVal
        when true
          icon = 'check'
          color = 'green'
        when false
          icon = 'close'
          color = 'red'
        else currentVal
      $sce.trustAsHtml('<md-icon class="material-icons" style="color:' + color + '">' + icon + '</md-icon>')

    getVals = (row, keys, flag, type = null) ->
      vals = ''
      currentKey = keys.shift()
      if currentKey is flag
        if row[currentKey]?.length > 0
          for sRow in row[currentKey]
            vals += getVal(sRow, angular.copy(keys), type) + '<br>'
        else
          vals = 'none'
      else
        getVals(row[currentKey], angular.copy(keys), flag, type)
      $sce.trustAsHtml(vals)

    showInlineDetail = (row) ->
      if row.expanded
        row.expanded = false
      else
        row.expanded = true
      return true

    getDetailTemplate = () ->
      @detailTemplate

    init()

angular
  .module('dataTableBaseComponents')
  .controller 'DataTableCtrl', DataTableCtrl
