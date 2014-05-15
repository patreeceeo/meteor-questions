
class App.ListQuestionsView extends ReactiveView
  template: Template.listQuestions

  els:
    masonry: '.js-masonry'
    questions: '.js-question'

  columnWidth: '24rem'

  helpers:
    questions: ->
      if @$els.masonry > []
        _.defer =>
          width = @_getConfig('columnWidth')
          @$els.questions.width(width)

          @masonry?.destroy()

          @masonry = new Masonry @$els.masonry[0],
            itemSelector: '.js-question'

      App.QuestionCollection.find().fetch()
