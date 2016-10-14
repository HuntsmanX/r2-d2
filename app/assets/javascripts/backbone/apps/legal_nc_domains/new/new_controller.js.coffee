@Artoo.module 'LegalNcDomainsApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends App.Controllers.Application
    
    initialize: (options) ->
      domain      = App.request 'new:nc:service:entity'
      { domains } = options
      
      newView = @getNewView domain
        
      form = App.request 'form:component', newView,
        proxy:     'modal'
        model:     domain
        onCancel:  => @region.empty()
        onSuccess: => @region.empty() and domains.search()
      
      @show form
          
    getNewView: (domain) ->
      schema = new New.Schema
      
      App.request 'form:fields:component',
        proxy:  'modal'
        schema: schema,
        model:  domain