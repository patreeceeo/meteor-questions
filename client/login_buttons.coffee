loginButtonsSession = Accounts._loginButtonsSession

# shared between dropdown and single mode
Template.loginButtons.events
  'click #login-buttons-logout': ->
    Meteor.logout ->
      loginButtonsSession.closeDropdown()

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

Template._loginButtonsLoggedInSingleLogoutButton.displayName = Accounts.ui.displayName
Template._loginButtonsLoggedInSingleLogoutButton.profilePicture = Accounts.ui.profilePicture
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
  'click .login-button': ->
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
    loginWithService = Meteor["loginWith#{
      if serviceName is 'meteor-developer'
       'MeteorDeveloperAccount'
      else
        capitalize serviceName
    }"]

    options = {} # use default scope unless specified
    if Accounts.ui._options.requestPermissions[serviceName]
      options.requestPermissions = Accounts.ui._options.requestPermissions[serviceName]
    if Accounts.ui._options.requestOfflineToken[serviceName]
      options.requestOfflineToken = Accounts.ui._options.requestOfflineToken[serviceName]

    loginWithService(options, callback)


Template._loginButtonsLoggedOutSingleLoginButton.configured = ->
  !!ServiceConfiguration.configurations.findOne service: @name


Template._loginButtonsLoggedOutSingleLoginButton.capitalizedName = ->
  if @name is 'github'
    # XXX we should allow service packages to set their capitalized name
    'GitHub'
  else if @name is 'meteor-developer'
    'Meteor'
  else
    capitalize @name


# XXX from http://epeli.github.com/underscore.string/lib/underscore.string.js
capitalize = (str) ->
  str = 
    if str?
      String(str)
    else
      ''
  str.charAt(0).toUpperCase() + str.slice(1)

