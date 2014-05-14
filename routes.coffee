

this.App ?= {}

App.routes = 
  index:
    path: '/'
    template: 'index'
    layoutTemplate: 'layout'
  listQuestions:
    path: 'list/:_idList'
    template: 'listQuestions'
    layoutTemplate: 'layout'
  questionPosed:
    path: 'question/:_idQuestion/posed'
    template: 'questionPosed'
    layoutTemplate: 'layout'
    waitOn: ->
      App.qModel.select @params._idQuestion
      App.aModel.select _idQuestion: @params._idQuestion
      Meteor.subscribe 'QuestionCollection', @params._idQuestion

  
