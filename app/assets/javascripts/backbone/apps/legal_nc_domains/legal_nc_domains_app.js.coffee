@Artoo.module 'LegalNcDomainsApp', (LegalNcDomainsApp, App, Backbone, Marionette, $, _) ->

  class LegalNcDomainsApp.Router extends App.Routers.Base

    appRoutes:
      'legal/nc_domains'     : 'list'
      'legal/nc_domains/:id' : 'show'

  API =

    list: (region) ->
      return App.execute 'legal:list', 'Namecheap Domains', 'list' if not region

      new LegalNcDomainsApp.List.Controller
        region: region

    newDomain: (domains) ->
      new LegalNcDomainsApp.New.Controller
        region:  App.modalRegion
        domains: domains

    show: (id, region) ->
      debugger
      return App.execute 'legal:list', 'Namecheap Domains', { action: 'show', id: id } if not region

      new LegalNcDomainsApp.Show.Controller
        region: region
        id:     id


  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'Namecheap Domains'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate 'legal/nc_domains'
      API.list region

    if action is 'show'
      debugger
      App.navigate "legal/nc_domains/#{options.id}"
      API.show options.id, region

  App.vent.on 'new:nc:domain:clicked', (domains) ->
    debugger
    API.newDomain domains

  App.vent.on 'show:nc:domain:clicked', (domains) ->
    debugger
    API.show domains.id


  LegalNcDomainsApp.on 'start', ->
    new LegalNcDomainsApp.Router
      controller: API