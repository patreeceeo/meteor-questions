#TODO: consider whether to create individual question 
#      view/template.

class App.ListQuestionsView extends ReactiveView
  template: Template.listQuestions

  els:
    masonry: '.js-masonry'
    questionWrapper: '.js-question'
    question: '.js-question .u-isActionable'

  columnWidth: '24rem'

  ready: ->
    if @$els.masonry > []
      width = @_getConfig('columnWidth')
      @$els.questionWrapper.width(width)

      @masonry = new Masonry @$els.masonry[0],
        itemSelector: '.js-question'

  destroyed: =>
    @masonry?.destroy()

  helpers:
    questions: ->
      App.QuestionCollection.find()
