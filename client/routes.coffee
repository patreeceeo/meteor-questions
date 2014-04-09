


Router.map ->
  @route 'index',
    path: '/'
  @route 'questionPosed',
    path: 'questions/:_idList/posed/:_idQuestionPosed'
    action: ->
      @render()

  
