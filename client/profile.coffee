
class App.ProfileView extends ReactiveView
  template: Template.profile
  helpers:
    profilePicture: ->
      Accounts.ui.profilePicture @model.get('_id')
    displayName: ->
      Accounts.ui.displayName @model.get('_id')
    _idUser: ->
      @model.get('_id')
