@Artoo.module 'LegalNcDomainsApp.List', (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.LayoutView
    template: 'legal_nc_domains/list/layout'

    regions:
      panelRegion:      '#panel-region'
      searchRegion:     '#search-region'
      domainsRegion:    '#domains-region'
      paginationRegion: '#pagination-region'


  class List.Panel extends App.Views.ItemView
    template: 'legal_nc_domains/list/panel'

    triggers:
      'click a' : 'new:watched:domain:clicked'

    serializeData: ->
      canCreate: App.ability.can 'create', 'NcService'


  class List.SearchSchema extends Marionette.Object

    form:
      buttons:
        primary:   'Search'
        cancel:    false
        placement: 'left'
      syncingType: 'buttons'
      focusFirstInput: false
      search: true

    schema: ->
      [
        legend:    'Filters'
        isCompact: true

        fields: [
          name:     'name'
          label:    'Name contains'
        ,
          name:     'name_cont'
          label:    'Username contains'
        ,
          name:     'status_eq'
          label:    'Has Status'
          tagName:  'select'
          options:  @getStatus()
        ,
          name:     'count'
          label:    'Entries per page'
          default:  '25'
        ]
      ]
    getStatus: -> App.entities.legal.service_status

  class List.DomainView extends App.Views.ItemView
    template: 'legal_nc_domains/list/_domain'

    tagName: 'li'

    triggers:
      'click .delete-domain' : 'delete:clicked'

    serializeData: ->
      data = super
      data.canDestroy = App.ability.can 'destroy', @model
      data


  class List.DomainsView extends App.Views.CompositeView
    template: 'legal_nc_domains/list/domains'

    childView:          List.DomainView
    childViewContainer: 'ul'

    collectionEvents:
      'collection:sync:start' : 'syncStart'
      'collection:sync:stop'  : 'syncStop'

    syncStart: ->
      @addOpacityWrapper()

    syncStop: ->
      @addOpacityWrapper false

    onDestroy: ->
      @addOpacityWrapper false