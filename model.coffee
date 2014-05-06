
App.QuestionCollection = new Meteor.Collection 'QuestionCollection'

Question =
  _id: String
  question: String

class App.QuestionModel extends ReactiveModel
  collection: -> App.QuestionCollection
  defaults: 
    question: ''


if Meteor.isServer
  Meteor.publish 'QuestionCollection', -> App.QuestionCollection.find()
else
  Meteor.subscribe 'QuestionCollection'

Meteor.startup ->
  App.QuestionCollection.allow
    insert: (_idUser, document) ->
      check(document, Question)
      true
    update: (_idUser, document) ->
      check(document, Question)
      true
    remove: (_idUser, document) ->
      check(document, Question)
      true


App.AnswerCollection = new Meteor.Collection 'AnswerCollection'

Answer =
  _id: String
  _idQuestion: String
  answer: String

class App.AnswerModel extends ReactiveModel
  collection: -> App.AnswerCollection
  defaults:
    answer: ''
  otherAnswers: ->
    @collection.find
      $and: [
        { _idQuestion: "#{@get '_idQuestion'}" }
        { _id: $ne: @get '_id' }
      ]

if Meteor.isServer
  Meteor.publish 'AnswerCollection', -> App.AnswerCollection.find()
else
  Meteor.subscribe 'AnswerCollection'

Meteor.startup ->
  App.AnswerCollection.allow
    insert: (_idUser, document) ->
      check(document, Answer)
      true
    update: (_idUser, document) ->
      check(document, Answer)
      true
    remove: (_idUser, document) ->
      check(document, Answer)
      true
