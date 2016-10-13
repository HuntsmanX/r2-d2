@Artoo.module 'LegalNcDomainsApp', (LegalNcDomainsApp, App, Backbone, Marionette, $, _) ->

  class LegalNcDomainsApp.Router extends App.Routers.Base

    appRoutes:
      'legal/nc_domains' : 'list'

  API =

    list: (region) ->
      return App.execute 'legal:list', 'Namecheap Domains', 'list' if not region

      new LegalNcDomainsApp.List.Controller
        region: region

    newDomain: (domains) ->
      new LegalNcDomainsApp.New.Controller
        region:  App.modalRegion
        domains: domains


  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'Namecheap Domains'

    action = options?.action
    action ?= 'list'

    if action is 'list'
      App.navigate 'legal/nc_domains'
      API.list region


  App.vent.on 'new:watched:domain:clicked', (domains) ->
    API.newDomain domains


  LegalNcDomainsApp.on 'start', ->
    new LegalNcDomainsApp.Router
      controller: API