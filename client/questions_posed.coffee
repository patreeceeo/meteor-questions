
class App.QuestionPosedView extends ReactiveView
  template: Template.questionPosed
  events:
    'click .QuestionPosed-submitButton': (event) ->
      answer = @$('.QuestionPosed-textarea').val()

      @config.aModel.inset
        answer: answer

    'click .QuestionPosed-resetButton': (event) ->
      @config.aModel.remove()

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

  initialize: ->


      

Meteor.startup ->




