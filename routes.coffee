

this.App ?= {}

App.routes = 
  index:
    path: '/'
    template: 'index'
    layoutTemplate: 'layout'
  about:
    path: '/about'
    template: 'about'
    layoutTemplate: 'layout'
  profile:
    path: '/user/:_idUser/profile'
    template: 'profile'
    layoutTemplate: 'layout'
  listQuestions:
    path: 'list/:_idList'
    template: 'listQuestions'
    layoutTemplate: 'layout'
    waitOn: ->
      Meteor.subscribe 'QuestionCollection', {}
  questionPosed:
    path: 'question/:_idQuestion/posed'
    template: 'questionPosed'
    layoutTemplate: 'layout'
    waitOn: ->
      Meteor.subscribe 'AnswerCollection', _idQuestion: @params._idQuestion,
        onReady: =>
          App.aModel.select _idQuestion: @params._idQuestion

      Meteor.subscribe 'QuestionCollection', @params._idQuestion,
        onReady: =>
          App.qModel.select @params._idQuestion

  
