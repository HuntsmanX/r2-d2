@Artoo.module 'ToolsDataExtractorApp', (ToolsDataExtractorApp, App, Backbone, Marionette, $, _) ->

  class ToolsDataExtractorApp.Router extends App.Routers.Base

    appRoutes:
      'tools/data_extractor' : 'newSearch'

  API =

    newSearch: (region) ->
      return App.execute 'tools:list', 'Data Extractor', { action: 'newSearch' } if not region

      new ToolsDataExtractorApp.New.Controller
        region: region

    show: (dataSearch) ->
      new ToolsDataExtractorApp.Show.Controller
        region:     App.modalRegion
        dataSearch: dataSearch


  App.vent.on 'tools:nav:selected', (nav, options, region) ->
    return if nav isnt 'Data Extractor'

    action = options?.action
    action ?= 'newSearch'

    if action is 'newSearch'
      App.navigate '/tools/data_extractor'
      API.newSearch region

  App.vent.on 'more:info:clicked', (dataSearch) ->
    API.show dataSearch


  ToolsDataExtractorApp.on 'start', ->
    new ToolsDataExtractorApp.Router
      controller: API
