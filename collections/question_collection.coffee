
App.QuestionCollection = new Meteor.Collection 'QuestionCollection'

Question =
  _id: String
  question: String

class App.QuestionModel extends App.Model
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



