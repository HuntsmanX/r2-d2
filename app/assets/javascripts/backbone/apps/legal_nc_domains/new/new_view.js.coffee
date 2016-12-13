@Artoo.module 'LegalNcDomainsApp.New', (New, App, Backbone, Marionette, $, _) ->
  
  class New.Schema extends Marionette.Object
    
    modal:
      size:  'tiny'
      title: 'New Domain'
    
    schema: ->
      [
        legend:   'New Domain'
        hasHints: false
        id:         'nc_service'

        fields: [
          name:    'nc_service[name]'
          label:   'Name'
        ,
          name:     'nc_service[new_status]'
          label:    'Status'
          tagName:  'select'
          options:  @getStatus()
        ,
          name:    'nc_service[username]'
          label:   'Namecheap username'
        ,
          name:    'nc_service[nc_service_type_id]'
          type:     'hidden'
          value: '1'
        ]
      ]
    getStatus: -> App.entities.legal.service_status