# Session.set 'questionPosedID', '0'

Deps.autorun ->
  Router.activeController?.params._idQuestionPosed

Template.questionPosed.events
  'keydown textarea': (event) ->
    if (event.which || event.keyCode) is 13
      AnswerCollection.insert
        answer: $(event.target).val()
        _idQuestion: get_idQuestionPosed()
        Router.go 'questionPosed', 
          _idList: 0
          _idQuestionPosed: 1

Template.questionPosed.helpers
  questionAnswered: ->
    QuestionWithAnswerCollection.find _id: $not: get_idQuestionPosed()

  questionPosed: ->
    QuestionCollection.find _id: get_idQuestionPosed()

