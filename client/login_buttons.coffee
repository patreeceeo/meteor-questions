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

