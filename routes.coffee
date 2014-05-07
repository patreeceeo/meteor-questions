

this.App ?= {}

App.routes = 
  index:
    path: '/'
    template: 'index'
  questionPosed:
    path: 'questions/:_idQuestion/posed'
    template: 'questionPosed'
    waitOn: ->
      App.qModel.select @params._idQuestion
      App.aModel.select _idQuestion: @params._idQuestion
      Meteor.subscribe 'QuestionCollection', @params._idQuestion

  
