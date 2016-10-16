@Artoo.module 'LegalNcDomainsApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.LayoutView
    debugger
    template: 'legal_nc_domains/show/layout'

    regions:
      tableRegion:      '#requests-table-region'


  class Show.Table extends App.Views.ItemView
    template: 'legal_nc_domains/show/table'
    modelEvents:
      'change' : 'render'