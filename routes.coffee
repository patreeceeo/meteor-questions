

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
      App.aModel.select @params._idQuestion
      Meteor.subscribe 'QuestionCollection', @params._idQuestion
    # action: ->
    #   App.questionPosedView ?= new App.QuestionPosedView
    #   App.questionPosedView.load
    #     _idQuestion: parseInt @params._idQuestion
    #     _idList: parseInt @params._idList
    #   @render()

  
