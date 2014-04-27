

# testAsyncMulti "ReactiveModel - test test", [
#   (test, expect) ->
#     test.equal 5, 5
# ]

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

    kimchi0 = new Kimchi '0'

    test.equal kimchi0.get('name'), 'cabbage',
      "kimchi 0 should be named 'cabbage'"

    kimchi0.set 'name', 'spicy cabbage', success: ->
      test.equal kimchi0.get('name'), 'spicy cabbage', "kimchi 0 should still be named 'spicy cabbage'"
      done()

    test.equal kimchi0.get('name'), 'spicy cabbage',
      "kimchi 0 should immediately be re-named 'spicy cabbage'"

    kimchi0.set {
      name: "spicy cabbage"
      origin: "Korea"
    }, 
      success: ->
        test.equal kimchi0.get('origin'), 'Korea', "kimchi 0 should still be from Korea"
        done()
        
    test.equal kimchi0.get('origin'), 'Korea',
      "kimchi 0's origin should immediately be set to Korea"

    




