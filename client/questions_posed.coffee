
class App.QuestionPosedView extends ReactiveView
  template: Template.questionPosed
  els:
    answerInput: 'textarea.js-answer'
    answerButton: 'button.js-answer'
    resetButton: 'button.js-reset'
    prevButton: 'button.js-prev'
    nextButton: 'button.js-next'
  events:
    'click answerButton': (event) ->
      answer = @$els.answerInput.val()

      @config.aModel.inset
        answer: answer

    'click resetButton': (event) ->
      @config.aModel.remove()

    'click nextButton': (event) ->
      nQuestions = App.QuestionCollection.find().count()
      Router.go 'questionPosed',
        _idQuestion: Math.min nQuestions, parseInt(@model.get('_id')) + 1

    'click prevButton': (event) ->
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




