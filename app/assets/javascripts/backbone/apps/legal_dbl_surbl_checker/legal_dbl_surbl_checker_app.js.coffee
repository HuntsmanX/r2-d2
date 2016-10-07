@Artoo.module 'LegalDblSurblCheckerApp', (LegalDblSurblCheckerApp, App, Backbone, Marionette, $, _) ->

  class LegalDblSurblCheckerApp.Router extends App.Routers.Base

    appRoutes:
      'legal/dbl_surbl' : 'newDblSurblCheck'

  API =

    newDblSurblCheck: (region) ->
      return App.execute 'legal:list', 'DBL/SURBL Check', { action: 'new' } if not region

      new LegalDblSurblCheckerApp.New.Controller
        region: region


  App.vent.on 'legal:nav:selected', (nav, options, region) ->
    return if nav isnt 'DBL/SURBL Check'

    action = options?.action
    action ?= 'new'

    if action is 'new'
      App.navigate '/legal/dbl_surbl'
      API.newDblSurblCheck region

  LegalDblSurblCheckerApp.on 'start', ->
    new LegalDblSurblCheckerApp.Router
      controller: API