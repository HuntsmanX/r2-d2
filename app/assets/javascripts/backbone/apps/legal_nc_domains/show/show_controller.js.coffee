@Artoo.module 'LegalNcDomainsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Application

    initialize: (options) ->
      domain = App.request 'nc:domain:entity', options.id
      window.domain = domain

      @layout = @getLayoutView()
      @listenTo @layout, 'show', =>
        @tableRegion domain
        @panelRegion domain
        
      @show @layout

    panelRegion: (domain) ->
      panelView = @getPanelView()

      @listenTo panelView, 'new:nc:comment:clicked', (args) ->
        App.vent.trigger 'new:nc:comment:clicked', domain

      @show panelView, region: @layout.panelRegion

    tableRegion: (domain) ->
      tableView = @getTableView domain

      App.execute 'when:synced', domain, =>
        @show tableView, region: @layout.tableRegion

    getTableView: (domain) ->
      new Show.Table
        collection: domain.directReports

    getLayoutView: ->
      new Show.Layout

    getPanelView: ->
      new Show.Panel