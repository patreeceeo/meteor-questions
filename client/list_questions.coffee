
class App.ListQuestionsView extends ReactiveView
  template: Template.listQuestions

  els:
    masonry: '.js-masonry'

  helpers:
    questions: ->
      if @$els.masonry > []
        _.defer =>
          @masonry = new Masonry @$els.masonry[0],
            itemSelector: '.js-question'
            columnWidth: 200
      App.QuestionCollection.find().fetch()
