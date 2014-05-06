
this.App ?= {}

App.qModel = qModel = new App.QuestionModel

if Meteor.isClient
  App.qpView = new App.QuestionPosedView
    model: qModel

Router.map ->
  for own key, value of App.routes
    @route key, value
