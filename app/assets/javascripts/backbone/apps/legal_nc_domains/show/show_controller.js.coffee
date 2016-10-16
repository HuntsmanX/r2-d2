@Artoo.module 'LegalNcDomainsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Application

    initialize: (options) ->
      domain = App.request 'nc:domain:entity', options.id
      window.domain = domain

      @layout = @getLayoutView()
      @listenTo @layout, 'show', =>
        @tableRegion domain
        
      @show @layout

    tableRegion: (domain) ->
      tableView = @getTableView domain

      App.execute 'when:synced', domain, =>
        @show tableView, region: @layout.tableRegion

    getTableView: (domain) ->
      new Show.Table
        model: domain

    getLayoutView: ->
      new Show.Layout  