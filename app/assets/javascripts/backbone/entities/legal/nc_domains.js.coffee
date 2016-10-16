@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.NcDomain extends App.Entities.Model
    urlRoot: -> Routes.legal_nc_domains_path()

    resourceName: 'NcService'


  class Entities.WatchedNcDomainsCollection extends App.Entities.Collection
    model: Entities.NcDomain

    url: -> Routes.legal_nc_domains_path()


  API =

    getWatchedNcDomainsCollection: ->
      domains = new Entities.WatchedNcDomainsCollection
      domains.fetch()
      domains

    getNewWatchedNcDomain: ->
      new Entities.NcDomain

    getNcDomain: (id) ->
      domains = new Entities.NcDomain id: id
      domains.fetch()
      domains  

  App.reqres.setHandler 'watched:nc:domain:entities', ->
    API.getWatchedNcDomainsCollection()

  App.reqres.setHandler 'new:nc:service:entity', ->
    API.getNewWatchedNcDomain()

  App.reqres.setHandler 'nc:domain:entity', (id) ->
    API.getNcDomain id  