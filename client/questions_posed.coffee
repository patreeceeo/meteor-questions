# Session.set 'questionPosedID', '0'


Template.questionPosed.events
  'keydown textarea': (event) ->
    if (event.which || event.keyCode) is 13
      answer = $(event.target).val()
      _idQuestion = $(event.target).data().idQuestion

      Question.addAnswer answer, _idQuestion

Template.questionPosed.helpers
  questionAnswered: ->
    Question.AnswerCollection.find().map (answer) ->
      answer.question = Question.Collection.findOne(answer._idQuestion)?.question or "WAT>?"
      answer

  questionPosed: ->
    Question.Collection.find()

