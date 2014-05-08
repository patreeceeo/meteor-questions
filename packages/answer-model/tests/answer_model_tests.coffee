
collection = App.AnswerCollection
if Meteor.isServer
  collection.remove({})

xTinytest =
  add: ->
  addAsync: ->

if Meteor.isClient
  arr = [
    { answer: 'Jax Beach', _idUser: '0', _idQuestion: '0' }
    { answer: 'Rockaway Beach', _idUser: '1', _idQuestion: '0' }
    { answer: 'Santa Cruz', _idUser: '2', _idQuestion: '0' }
    { answer: 'KOA', _idUser: '0', _idQuestion: '1' }
  ]
  
  for doc in arr
    collection.insert doc

  Tinytest.add 'AnswerModel - otherAnswers()', (test) ->

    model = new AnswerModel _idUser: '0', _idQuestion: '0'

    otherAnswers = model.otherAnswers()
    test.equal otherAnswers.count(), 2, 
      'should return a cursor to the other answers to the 
      same question'
    test.isFalse model._id in _.pluck(otherAnswers.fetch(), '_id'),
      'should return a cursor to the other answers to the 
      same question'


  Tinytest.add 'AnswerModel - default _idUser', (test) ->

    Meteor.userId = ->
      'faceb00b'

    model = new AnswerModel()

    test.equal model.get('_idUser'), 'faceb00b', 
      'should default to the current user ID'

  Tinytest.add 'AnswerModel - submit()', (test) ->

    model = new AnswerModel()

    model.submit '0', 'Cape Horn'

    

