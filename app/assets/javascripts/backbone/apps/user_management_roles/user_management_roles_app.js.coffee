@Artoo.module 'UserManagementRolesApp', (UserManagementRolesApp, App, Backbone, Marionette, $, _) ->
  
  class UserManagementRolesApp.Router extends App.Routers.Base
    
    appRoutes:
      'user_management/roles'          : 'list'
      'user_management/roles/:id/edit' : 'editPermissions'
      
  API =
    
    list: (region) ->
      return App.execute 'user:management:list', 'Roles & Permissions', { action: 'list' } if not region
      
      new UserManagementRolesApp.List.Controller
        region: region
    
    editPermissions: (id, region) ->
      return App.execute 'user:management:list', 'Roles & Permissions', { action: 'editPermissions', id: id } if not region
      
      new UserManagementRolesApp.EditPermissions.Controller
        region: region
        id:     id
    
    editGroups: (role) ->
      new UserManagementRolesApp.EditGroups.Controller
        region: App.modalRegion
        role:   role
        
        
  App.vent.on 'user:management:nav:selected', (nav, options, region) ->
    return if nav isnt 'Roles & Permissions'
    
    action = options?.action
    action ?= 'list'
      
    if action is 'list'
      App.navigate '/user_management/roles'
      API.list region
      
    if action is 'editPermissions'
      App.navigate "/user_management/roles/#{options.id}/edit"
      API.editPermissions options.id, region
      
  App.vent.on 'edit:groups:clicked', (role) ->
    API.editGroups role
    
  App.vent.on 'edit:permissions:clicked', (role) ->
    API.editPermissions role.id
  
  
  UserManagementRolesApp.on 'start', ->
    new UserManagementRolesApp.Router
      controller: API