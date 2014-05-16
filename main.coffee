
this.App ?= {}

App.qModel = qModel = new App.QuestionModel
App.aModel = aModel = new App.AnswerModel

if Meteor.isServer
  # Need to publish 'services' field to 'userData' because it
  # isn't published by default and its needed to get stuff
  # like the profile picture for the current user from 
  # Meteor.user()
  Meteor.publish "userData", ->
    Meteor.users.find @userId, fields: services: 1

if Meteor.isClient
  App.qpView = new App.QuestionPosedView
    model: qModel
    aModel: aModel

  App.lqView = new App.ListQuestionsView

Router.waitOn ->
  Meteor.subscribe 'userData'

Router.map ->
  for own key, value of App.routes
    @route key, value


