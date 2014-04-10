


Router.map ->
  @route 'index',
    path: '/'
  @route 'questionPosed',
    path: 'questions/:_idList/posed'
    action: ->
      @render()

  
