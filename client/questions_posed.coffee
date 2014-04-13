


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


class App.QuestionPosedView extends View
  template: Template.questionPosed
  events:
    answerQuestion:
      event: 'click'
      block: 'QuestionPosed'
      element: 'submitButton'
      callback: (event) ->
        answer = @find(
          block: 'QuestionPosed'
          element: 'textarea'
        ).val()

        @answerModel.set 
          answer: answer, 
          _idQuestion: @questionModel.get('_id')

    resetQuestion:
      event: 'click'
      block: 'QuestionPosed'
      element: 'resetButton'
      callback: (event) ->
        @answerModel.remove()

    nextQuestion:
      event: 'click'
      block: 'QuestionPosed'
      element: 'nextButton'
      callback: (event) ->
        Router.go 'questionPosed',
          _idList: 0
          _idQuestion: @options._idQuestion + 1

    prevQuestion:
      event: 'click'
      block: 'QuestionPosed'
      element: 'prevButton'
      callback: (event) ->
        if @options._idQuestion > 0
          Router.go 'questionPosed',
            _idList: 0
            _idQuestion: @options._idQuestion - 1

  dataHelpers:
    answer: ->
      @dep.depend()
      @answerModel.get 'answer'

    question: ->
      @dep.depend()
      @questionModel.get 'question'


    answerPlaceholder: ->
      [
        'Get it all out'
        'Tell me how you REALLY feel'
        'What says you?'
        'How `bout that'
        'Lay it on me'
      ][Math.floor(Math.random() * 5)]

  initialize: (@options = {}) ->
    @options._idList ?= 0
    @options._idQuestion ?= 0
    @dep = new Deps.Dependency
    @load(@options)

  load: (@options) ->
    @questionModel = new App.QuestionModel options._idQuestion
    @answerModel = new App.AnswerModel options._idQuestion
    @dep.changed()
      

Meteor.startup ->




