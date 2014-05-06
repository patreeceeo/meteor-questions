
this.App ?= {}

App.qModel = qModel = new App.QuestionModel
App.aModel = aModel = new App.AnswerModel

if Meteor.isClient
  App.qpView = new App.QuestionPosedView
    model: qModel
    aModel: aModel

Router.map ->
  for own key, value of App.routes
    @route key, value
