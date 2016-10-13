@Artoo.module 'LegalNcDomainsApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Application

    initialize: (options) ->
      domains = App.request 'watched:nc:domain:entities'
      @layout = @getLayoutView()
      @listenTo @layout, 'show', =>
        @panelRegion domains
        @searchRegion domains
        @domainsRegion domains
        @paginationRegion domains
  
      @show @layout
  
    panelRegion: (domains) ->
      panelView = @getPanelView()
  
      @listenTo panelView, 'new:watched:domain:clicked', (args) ->
        App.vent.trigger 'new:watched:domain:clicked', domains
  
      @show panelView, region: @layout.panelRegion
  
    searchRegion: (domains) ->
      searchView = @getSearchView()
  
      formView = App.request 'form:component', searchView,
        model: false
  
      @listenTo formView, 'form:submit', (data) ->
        domains.search data
  
      @show formView, region: @layout.searchRegion
  
    domainsRegion: (domains) ->
      domainsView = @getDomainsView domains
  
      @listenTo domainsView, 'childview:delete:clicked', (child, args) ->
        model = args.model
        if confirm "Are you sure you want to delete #{model.get("name")}?" then model.destroy() else false
  
      @show domainsView,
        loading: true
        region:  @layout.domainsRegion
  
    paginationRegion: (domains) ->
      pagination = App.request 'pagination:component', domains
  
      App.execute 'when:synced', domains, =>
        @show pagination, region: @layout.paginationRegion if @layout.paginationRegion
  
    getDomainsView: (domains) ->
      new List.DomainsView
        collection: domains
  
    getSearchView: ->
      schema = new List.SearchSchema
      App.request 'form:fields:component',
        schema:  schema
        model:   false
  
    getPanelView: ->
      new List.Panel
  
    getLayoutView: ->
      new List.Layout