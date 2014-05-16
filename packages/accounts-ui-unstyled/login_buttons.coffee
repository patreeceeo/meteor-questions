
# for convenience
loginButtonsSession = Accounts._loginButtonsSession

# shared between dropdown and single mode
Template.loginButtons.events
  'click #login-buttons-logout': ->
    Meteor.logout ->
      loginButtonsSession.closeDropdown()

UI.registerHelper 'loginButtons', ->
  throw new Error "Use {{> loginButtons}} instead of {{loginButtons}}"


#
# helpers
#

Accounts.ui.displayName = ->
  user = Meteor.user()

  user?.profile?.name.split(/\s+/)[0] or ''




Accounts.ui.profilePicture = ->
  if Meteor.user().services?
    id = Meteor.user().services.facebook.id
    "http://graph.facebook.com/#{id}/picture/?type=small"
  else
    ""


# returns an array of the login services used by this app. each
# element of the array is an object (eg {name: 'facebook'}), since
# that makes it useful in combination with handlebars {{#each}}.
#
# don't cache the output of this function: if called during startup (before
# oauth packages load) it might not include them all.
#
# NOTE: It is very important to have this return password last
# because of the way we render the different providers in
# login_buttons_dropdown.html
Accounts.ui.getLoginServices = ->
  # First look for OAuth services.
  services = 
    if Package['accounts-oauth'] 
      Accounts.oauth.serviceNames() 
    else
      []

  # Be equally kind to all login services. This also preserves
  # backwards-compatibility. (But maybe order should be
  # configurable?)
  services.sort()

  # Add password, if it's there; it must come last.
  if Accounts.ui.hasPasswordService()
    services.push 'password'

  _.map services, (name) ->
    name: name

Accounts.ui.hasPasswordService = ->
  return !!Package['accounts-password']


Accounts.ui.dropdown = ->
  return Accounts.ui.hasPasswordService() or Accounts.ui.getLoginServices().length > 1


# XXX improve these. should this be in accounts-password instead?
#
# XXX these will become configurable, and will be validated on
# the server as well.
validateUsername = (username) ->
  if username.length >= 3 
    true
  else
    loginButtonsSession.errorMessage("Username must be at least 3 characters long");
    false

validateEmail = (email) ->
  if passwordSignupFields() is "USERNAME_AND_OPTIONAL_EMAIL" and email is ''
    return true

  if email.indexOf('@') isnt -1
    return true
  else 
    loginButtonsSession.errorMessage("Invalid email")
    return false

validatePassword = (password) ->
  if password.length >= 6
    return true
  else
    loginButtonsSession.errorMessage("Password must be at least 6 characters long")
    return false

#
# loginButtonLoggedOut template
#

Template._loginButtonsLoggedOut.dropdown = Accounts.ui.dropdown

Template._loginButtonsLoggedOut.services = Accounts.ui.getLoginServices

Template._loginButtonsLoggedOut.singleService = ->
  services = Accounts.ui.getLoginServices()
  if services.length isnt 1
    throw new Error "Shouldn't be rendering this template 
      with more than one configured service"
  return services[0]


Template._loginButtonsLoggedOut.configurationLoaded = ->
  return Accounts.loginServicesConfigured()



#
# loginButtonsLoggedIn template
#

# decide whether we should show a dropdown rather than a row of
# buttons
Template._loginButtonsLoggedIn.dropdown = Accounts.ui.dropdown



#
# loginButtonsLoggedInSingleLogoutButton template
#

Template._loginButtonsLoggedInSingleLogoutButton.displayName = Accounts.ui.displayName
Template._loginButtonsLoggedInSingleLogoutButton.profilePicture = Accounts.ui.profilePicture



#
# loginButtonsMessage template
#

Template._loginButtonsMessages.errorMessage = ->
  return loginButtonsSession.get 'errorMessage'


Template._loginButtonsMessages.infoMessage = ->
  return loginButtonsSession.get 'infoMessage'



#
# loginButtonsLoggingInPadding template
#

Template._loginButtonsLoggingInPadding.dropdown = Accounts.ui.dropdown

