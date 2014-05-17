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
      cursor = App.QuestionCollection.find()
      if cursor.count() > 0
        _.defer =>
          if @$els.masonry > []
            width = @_getConfig('columnWidth')
            @$els.questionWrapper.width(width)

            @masonry?.destroy()

            @masonry = new Masonry @$els.masonry[0],
              itemSelector: '.js-question'

      cursor


