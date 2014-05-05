
window.App ?= {}

App.qpModel = qpModel = new QuestionPosedModel

if Meteor.isClient
  App.qpView = new QuestionPosedView
    model: qpModel

Router.map ->
  for own key, value of App.routes
    @route key, value
