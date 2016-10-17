@Artoo.module 'LegalNcDomainsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.LayoutView
    template: 'legal_nc_domains/show/layout'

    regions:
      tableRegion:      '#requests-table-region'
      panelRegion:      '#panel-region'  


  class Show.Panel extends App.Views.ItemView
    template: 'legal_nc_domains/show/panel'

    triggers:
      'click a' : 'new:nc:comment:clicked'

    serializeData: ->
      canCreate: App.ability.can 'create', 'NcService'
      
  class Show.Header extends App.Views.ItemView
    template: 'legal_nc_domains/show/result_header'

    triggers:
      'click .expand-toggle'    : 'toggle:clicked'

    onToggleClicked: ->
      @$el.toggleClass 'expanded'
      @$('.expand').toggle 200

      @$('.header a.toggle').toggleClass      'expanded'
      @$('.header a.toggle icon').toggleClass 'fa-rotate-180'

  class Show.Additional extends App.Views.ItemView

    getTemplate: ->
      console.log( @model.get('abuse_report_type_id'))
      return 'legal_nc_domains/show/_abuse_notes' if @model.get('abuse_report_type_id') == 'Abuse Notes'
      return 'legal_nc_domains/show/_dns_ddos'    if @model.get('abuse_report_type_id') == 'DNS DDoS'


  class Show.Report extends App.Views.LayoutView
    template: 'legal_nc_domains/show/result'
    tagName:  'li'

    regions:
      headerRegion:     '.header'
      additionalRegion: '.additional'

    onShow: ->
      headerView = new Show.Header model: @model
      @headerRegion.show headerView

      additonalView = new Show.Additional model: @model
      @additionalRegion.show additonalView

  class Show.Table extends App.Views.CompositeView
    template: 'legal_nc_domains/show/table'

    childView: Show.Report
    childViewContainer: 'ul'
    
    modelEvents:
      'change' : 'render'