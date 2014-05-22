
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

  if Meteor.isServer and 
      App.QuestionCollection.find().count() is 0
    App.bootstrap()


class App.UserModel extends ReactiveModel
  collection: Meteor.users
