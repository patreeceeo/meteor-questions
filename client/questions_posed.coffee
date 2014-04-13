


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


class QuestionPosedView extends View
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

  dataHelpers:
    answer: ->
      @answerModel.get 'answer'

    question: ->
      @questionModel.get 'question'

  initialize: ->
    @questionModel = new App.QuestionModel '0'
    @questionModel.insert()
    @answerModel = new App.AnswerModel '0'
    @answerModel.insert _idQuestion: '0'
      

Meteor.startup ->
  new QuestionPosedView




