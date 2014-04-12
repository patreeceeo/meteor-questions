


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

class QuestionModel extends App.Model
  collection: -> App.QuestionCollection

class AnswerModel extends App.Model
  collection: -> App.QuestionCollection

class QuestionPosedView extends View
  template: Template.questionPosed
  events:
    answerQuestion:
      event: 'keydown'
      block: 'QuestionPosed'
      element: 'textarea'
      callback: (event) ->
        if (event.which || event.keyCode) is 13
          answer = $(event.target).val()

          @answerModel.set 
            answer: answer, 
            _idQuestion: @questionModel.get('_id')

  dataHelpers:
    # questionAnswered: ->
    #   App.AnswerCollection.find().map (answer) ->
    #     answer.question = App.QuestionCollection.findOne(answer._idQuestion)?.question or "WAT>?"
    #     answer
    answer: ->
      @answerModel.get 'answer'

    question: ->
      @questionModel.get 'question'

  initialize: ->
    @questionModel = new QuestionModel '0'
    @answerModel = new AnswerModel _idQuestion: '0'
      

Meteor.startup ->
  new QuestionPosedView




