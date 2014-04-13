
App.AnswerCollection = new Meteor.Collection 'AnswerCollection'

Answer =
  _id: String
  _idQuestion: String
  answer: String

class App.AnswerModel extends App.Model
  collection: -> App.AnswerCollection
  defaults:
    answer: ''

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
