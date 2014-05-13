this.App ?= {}

App.AnswerCollection = new Meteor.Collection 'AnswerCollection'

class AnswerModel extends ReactiveModel
  collection: -> App.AnswerCollection
  defaults: ->
    _idUser: Meteor.isClient and Meteor.userId?()
    answer: ''
  otherAnswers: ->
    @collection.find
      $and: [
        { _idQuestion: "#{@get '_idQuestion'}" }
        { _id: $ne: @get '_id' }
      ]
  wantsAnswer: ->
    not @collection.findOne(
      _idQuestion: @get '_idQuestion'
      _idUser: @get '_idUser'
    )?



if Meteor.isServer
  Meteor.publish 'AnswerCollection', -> App.AnswerCollection.find()
else
  Meteor.subscribe 'AnswerCollection'

Meteor.startup ->
  Answer =
    _id: String
    _idQuestion: String
    _idUser: String
    answer: Match.Where (s) ->
      check s, String
      s.trim() > ''
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

App.AnswerModel = AnswerModel
