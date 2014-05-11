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
  # submit: (_idQuestion, answer) ->

Answer =
  _id: String
  _idQuestion: String
  _idUser: String
  answer: String

# check = (obj, spec) ->
#   for own key, value of spec
#     unless _.isString(obj[key])
#       throw "AnswerModel's #{key} must be a String"

# check = ->

if Meteor.isServer
  Meteor.publish 'AnswerCollection', -> App.AnswerCollection.find()
else
  Meteor.subscribe 'AnswerCollection'

Meteor.startup ->
  App.AnswerCollection.allow
    insert: (_idUser, document) ->
      check(document, Answer)
      not App.AnswerCollection.findOne(
        _idQuestion: document._idQuestion
        _idUser: document._idUser
      )?
    update: (_idUser, document) ->
      check(document, Answer)
      true
    remove: (_idUser, document) ->
      check(document, Answer)
      true

App.AnswerModel = AnswerModel
