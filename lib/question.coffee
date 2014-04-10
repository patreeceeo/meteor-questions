
this.Question = 
  addAnswer: (text, _idQuestion) ->
    _idQuestion = "#{_idQuestion}"
    Question.AnswerCollection.insert
      answer: text
      _idQuestion: _idQuestion
      

