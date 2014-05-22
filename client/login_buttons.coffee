loginButtonsSession = Accounts._loginButtonsSession

Template.loginButtons.helpers
  userId: ->
    Meteor.userId()

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
  services[0]


Template._loginButtonsLoggedOut.configurationLoaded = ->
  Accounts.loginServicesConfigured()



#
# loginButtonsLoggedIn template
#

# decide whether we should show a dropdown rather than a row of
# buttons
Template._loginButtonsLoggedIn.dropdown = Accounts.ui.dropdown



#
# loginButtonsLoggedInSingleLogoutButton template
#

Template._loginButtonsLoggedInSingleLogoutButton
  .displayName = ->
    Accounts.ui.displayName Meteor.userId()

Template._loginButtonsLoggedInSingleLogoutButton
  .profilePicture = ->
    Accounts.ui.profilePicture Meteor.userId()

Template._loginButtonsLoggedInSingleLogoutButton.greeting = ->
  [
    "Hello,"
    "Hola,"
    "Bonjour,"
    "Aloha,"
    "こんにちは (Kon'nichiwa)、"
    "你好 (Nǐ hǎo),"
    "Guten Tag,"
    "नमस्ते (Namastē),"
    "Dia duit,"
    "Алло (Allo),"
  ][Math.floor(Math.random() * 10)]


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

# for convenience
loginButtonsSession = Accounts._loginButtonsSession

Template._loginButtonsLoggedOutSingleLoginButton.events
  'click .js-login-button': ->
    serviceName = @name
    loginButtonsSession.resetMessages()
    callback = (err) ->
      unless err
        loginButtonsSession.closeDropdown()
      else if err instanceof Accounts.LoginCancelledError
        # do nothing
      else if err instanceof ServiceConfiguration.ConfigError
        loginButtonsSession.configureService(serviceName)
      else
        loginButtonsSession.errorMessage(err.reason or "Unknown error")

    # XXX Service providers should be able to specify their
    # `Meteor.loginWithX` method name.
    loginWithService = Meteor.loginWithFacebook

    options = {} # use default scope unless specified
    if Accounts.ui._options.requestPermissions[serviceName]
      options.requestPermissions = Accounts.ui._options.requestPermissions[serviceName]
    if Accounts.ui._options.requestOfflineToken[serviceName]
      options.requestOfflineToken = Accounts.ui._options.requestOfflineToken[serviceName]

    loginWithService(options, callback)


Template._loginButtonsLoggedOutSingleLoginButton.configured = ->
  !!ServiceConfiguration.configurations.findOne service: @name


Template.logoutButton.events
  'click button.js-logout': ->
    Meteor.logout ->
