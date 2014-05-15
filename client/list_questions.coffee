#TODO: consider whether to create individual question 
#      view/template.

class App.ListQuestionsView extends ReactiveView
  template: Template.listQuestions

  els:
    masonry: '.js-masonry'
    questionWrapper: '.js-question'
    question: '.js-question .u-isActionable'

  columnWidth: '24rem'

  helpers:
    questions: ->
      if @$els.masonry > []
        _.defer =>
          width = @_getConfig('columnWidth')
          @$els.questionWrapper.width(width)

          @masonry?.destroy()

          @masonry = new Masonry @$els.masonry[0],
            itemSelector: '.js-question'

      App.QuestionCollection.find().fetch()


