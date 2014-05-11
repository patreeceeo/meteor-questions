collection = App.AnswerCollection

if Meteor.isServer
  collection.remove({})

xTinytest =
  add: ->
  addAsync: ->



Meteor.userId = ->
  'faceb00b'

if Meteor.isClient
  arr = [
    { answer: 'Jax Beach', _idUser: '0', _idQuestion: '0' }
    { answer: 'Rockaway Beach', _idUser: '1', _idQuestion: '0' }
    { answer: 'Santa Cruz', _idUser: '2', _idQuestion: '0' }
    { answer: 'KOA', _idUser: '0', _idQuestion: '1' }
  ]
  
  for doc in arr
    collection.insert doc

  xTinytest.add 'AnswerModel - otherAnswers()', (test) ->

    model = new AnswerModel _idUser: '0', _idQuestion: '0'

    otherAnswers = model.otherAnswers()
    test.equal otherAnswers.count(), 2, 
      'should return a cursor to the other answers to the 
      same question'
    test.isFalse model._id in _.pluck(otherAnswers.fetch(), '_id'),
      'should return a cursor to the other answers to the 
      same question'


  xTinytest.add 'AnswerModel - default _idUser', (test) ->

    model = new AnswerModel()

    test.equal model.get('_idUser'), 'faceb00b', 
      'should default to the current user ID'

  Tinytest.add 'AnswerModel - submitting answers', (test) ->

    model = new AnswerModel
    model.select _idQuestion: '3', answer: 'Bikini Bottom'
    model.insert().then ->

      model.select _idQuestion: '3', answer: 'Myrtle Beach'
      model.insert().then ->

        cursor = App.AnswerCollection.find(
          _idQuestion: '3'
          _idUser: Meteor.userId()
        )

        test.equal cursor.count(), 1,
          'should not allow more than one answer per user per question'
        
        test.equal cursor.fetch()[0].answer, 'Myrtle Beach'

