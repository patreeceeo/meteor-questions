

window.App ?= {}

App.routes = 
  index:
    path: '/'
    template: 'index'
  questionPosed:
    path: 'list/:_idList/questions/:_idQuestion/posed'
    template: 'questionPosed'
    # action: ->
    #   App.questionPosedView ?= new App.QuestionPosedView
    #   App.questionPosedView.load
    #     _idQuestion: parseInt @params._idQuestion
    #     _idList: parseInt @params._idList
    #   @render()

  
