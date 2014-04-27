


this.Kimchis = new Meteor.Collection 'kimchis'
Kimchis.allow
  insert: -> true
  update: -> true
  remove: -> true

class Kimchi extends ReactiveModel
  collection: Kimchis

if Meteor.isClient

  Tinytest.addAsync 'ReactiveModel - get() and set()', (test, done) ->
    Kimchis.insert
      _id: '0'
      name: 'cabbage'

    kimchi = new Kimchi '0'

    test.equal kimchi.get('name'), 'cabbage',
      "kimchi 0 should be named 'cabbage'"

    kimchi.set 'name', 'spicy cabbage', success: ->
      test.equal kimchi.get('name'), 'spicy cabbage', "kimchi 0 should still be named 'spicy cabbage'"

    test.equal kimchi.get('name'), 'spicy cabbage',
      "kimchi 0 should immediately be re-named 'spicy cabbage'"

    kimchi.set {
      name: "spicy cabbage"
      origin: "Korea"
    }, 
      success: ->
        test.equal kimchi.get('origin'), 'Korea', "kimchi 0 should still be from Korea"
        done()
        
    test.equal kimchi.get('origin'), 'Korea',
      "kimchi 0's origin should immediately be set to Korea"

    
  Tinytest.addAsync 'ReactiveModel - reactivity', (test, done) ->

    kimchi0Name = 'cabbage'
    kimchi0Changed = false

    Kimchis.insert
      _id: '0'
      name: kimchi0Name

    Kimchis.insert
      _id: '1'
      name: 'raddish'

    kimchi0 = new Kimchi '0'
    kimchi1 = new Kimchi '1'

    Deps.autorun ->
      test.equal kimchi0.get('name'), kimchi0Name, 'Changes to model attributes should be reactive'
      if kimchi0Changed
        done()

    kimchi0Name = 'spicy cabbage'
    kimchi0Changed = true
    kimchi0.set 'name', kimchi0Name







