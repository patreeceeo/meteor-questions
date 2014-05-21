class CardView extends ReactiveView
  template: Template.questionPosed_card
  els:
    answerInput: 'textarea.js-answer'
    answerButton: 'button.js-answer'
    resetButton: 'button.js-reset'
  helpers:
    answer: ->
      @config.aModel.get 'answer'

    otherAnswers: ->
      @config.aModel.otherAnswers()

    question: ->
      @model.get 'question'

    userId: ->
      Meteor.userId()

    profilePicture: Accounts.ui.profilePicture

    answerPlaceholder: ->
      [
        'Get it all out'
        'Tell me how you REALLY feel'
        'What says you?'
        'How `bout that'
        'Lay it on me'
      ][Math.floor(Math.random() * 5)]
  submitAnswer: (event) ->
    answer = @$els.answerInput.val()

    @config.aModel.inset
      answer: answer
  events:
    'click answerButton': 'submitAnswer'

    'click resetButton': (event) ->
      @config.aModel.remove()

class App.QuestionPosedView extends ReactiveView
  template: Template.questionPosed
  els:
    prevButton: 'button.js-prev'
    nextButton: 'button.js-next'
  helpers: ->
    question: ->
      @model.get 'question'
  events:
    'click nextButton': (event) ->
      nQuestions = App.QuestionCollection.find().count()
      Router.go 'questionPosed',
        _idQuestion: Math.min nQuestions, parseInt(@model.get('_id')) + 1

    'click prevButton': (event) ->
      Router.go 'questionPosed',
        _idQuestion: Math.max 0, parseInt(@model.get('_id')) - 1
  initialize: ->
    @answerView = new ReactiveView
      template: Template.questionPosed_answer
      helpers:
        userId: ->
          Meteor.userId()
        profilePicture: (context) ->
          Accounts.ui.profilePicture context._idUser

    @cardView = new CardView
      model: @model
      aModel: @config.aModel

