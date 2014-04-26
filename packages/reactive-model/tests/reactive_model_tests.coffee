

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
  Kimchis.insert
    _id: '0'
    name: 'cabbage'
  Kimchis.insert
    _id: '1'
    name: 'raddish'

  kimchi0 = new Kimchi '0'
  kimchi1 = new Kimchi '1'

  Tinytest.add 'ReactiveModel - instantiation', (test) ->

    test.equal kimchi0.get('name'), 'cabbage',
      'kimchi 0 should be named "cabbage"'

  testAsyncMulti 'ReactiveModel - updating', [
    (test, expect) ->

      kimchi0.set 'name', 'spicy cabbage'

      test.equal kimchi0.get('name'), 'spicy cabbage',
        'kimchi 0 should now be named "spicy cabbage"'
  ]




