


Router.map ->
  @route 'index',
    path: '/'
  @route 'questionPosed',
    path: 'list/:_idList/questions/:_idQuestion/posed'
    action: ->
      App.questionPosedView ?= new App.QuestionPosedView
      App.questionPosedView.load
        _idQuestion: parseInt @params._idQuestion
        _idList: parseInt @params._idList
      @render()

  
