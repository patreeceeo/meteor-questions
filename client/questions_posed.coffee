


# Template.questionPosed.events
#   'keydown textarea': (event) ->
#     if (event.which || event.keyCode) is 13
#       answer = $(event.target).val()
#       _idQuestion = $(event.target).data().idQuestion

#       App.addAnswer answer, _idQuestion

# Template.questionPosed.helpers
#   questionAnswered: ->
#     App.AnswerCollection.find().map (answer) ->
#       answer.question = App.QuestionCollection.findOne(answer._idQuestion)?.question or "WAT>?"
#       answer

#   questionPosed: ->
#     App.QuestionCollection.find()


class App.QuestionPosedView extends ReactiveView
  template: Template.questionPosed
  events:
    'click .QuestionPosed-submitButton': (event) ->
      answer = @$('.QuestionPosed-textarea').val()

      @config.aModel.select(
        answer: answer
        _idQuestion: @model.get('_id')
      ).insert()

    'click .QuestionPosed-resetButton': (event) ->
      @model.unset 'answer', answer

    'click .QuestionPosed-nextButton': (event) ->
      nQuestions = App.QuestionCollection.find().count()
      Router.go 'questionPosed',
        _idQuestion: Math.min nQuestions, parseInt(@model.get('_id')) + 1

    'click .QuestionPosed-prevButton': (event) ->
      Router.go 'questionPosed',
        _idQuestion: Math.max 0, parseInt(@model.get('_id')) - 1

  helpers:
    answer: ->
      @config.aModel.get 'answer'

    otherAnswers: ->
      @config.aModel.otherAnswers()

    question: ->
      @model.get 'question'

    answerPlaceholder: ->
      [
        'Get it all out'
        'Tell me how you REALLY feel'
        'What says you?'
        'How `bout that'
        'Lay it on me'
      ][Math.floor(Math.random() * 5)]


  # load: (@options) ->


      

Meteor.startup ->




