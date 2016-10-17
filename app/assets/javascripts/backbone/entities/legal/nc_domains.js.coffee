@Artoo.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.AbuseReport extends App.Entities.Model

    mutators:
      proceedReport: ->
        if @get('processed') then 'Yes' else 'Not'

  class Entities.AbuseReportsCollection extends App.Entities.Collection
    model: Entities.AbuseReport

  class Entities.NcDomain extends App.Entities.Model
    urlRoot: -> Routes.legal_nc_domains_path()

    resourceName: 'NcService'

    initialize: ->
      @directReports = new Entities.AbuseReportsCollection
      @listenTo @, 'change:abuse_reports', =>
        @directReports.reset @get('abuse_reports')
        console.log @directReports

    mutators:
      images: ->
        class_str = ''
        if $.inArray('Abused out', @get('status_ids')) > -1
          class_str += '<icon class="fa fa-fire action"></icon>'
        if $.inArray('VIP', @get('status_ids')) > -1
          class_str += '<icon class="fa fa-diamond action"></icon>'
        if $.inArray('DDoS Related', @get('status_ids')) > -1
          class_str += '<icon class="fi-skull action"></icon>'
        if $.inArray('FreeDNS', @get('status_ids')) > -1
          class_str += ' <icon class="fi-trash action"></icon>'
        return class_str

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