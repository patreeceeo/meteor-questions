


this.Kimchis = new Meteor.Collection 'kimchis'

if Meteor.isServer
  Kimchis.remove({})
  Kimchis.allow
    insert: (userId, doc) -> 
      console.log 'inserting, doc:', doc
      true
    update: (userId, doc) -> 
      console.log 'updating, doc:', doc
      true
    remove: (userId, doc) -> 
      console.log 'removing, doc:', doc
      true

class Kimchi extends ReactiveModel
  collection: Kimchis
  defaults:
    fermentedForMonths: 9
    price: 8

xTinytest =
  add: ->
  addAsync: ->

if Meteor.isClient

  Tinytest.add 'ReactiveModel - get() and set()', (test, done) ->
    Kimchis.insert
      name: 'cabbage'

    kimchi = new Kimchi name: 'cabbage'

    test.equal kimchi.get('name'), 'cabbage',
      "kimchi 0 should be named 'cabbage'"

    kimchi.set 'name', 'spicy cabbage'    


    test.equal kimchi.get('name'), 'spicy cabbage',
      "kimchi 0 should immediately be re-named 'spicy cabbage'"

    kimchi.set {
      name: "spicy cabbage"
      origin: "Korea"
    } 
        
    test.equal kimchi.get('origin'), 'Korea',
      "kimchi 0's origin should immediately be set to Korea"

    
  Tinytest.addAsync 'ReactiveModel - reactivity', (test, done) ->
    callCount = 0
    changed = false

    Kimchis.insert
      name: 'cabbage'

    kimchi = new Kimchi name: 'cabbage'

    Deps.autorun ->
      name = kimchi.get('name')
      callCount++
      ###
TODO: figure out why this is being called more than twice
      My hypothesis is that Tinytest clears the local collections 
      when all tests have been started but before they're all 
      done. That's why I'm testing if `name` is defined.
      ###
      if changed and name?
        test.equal callCount, 2, 'One change to the model should only trigger one re-run'
        test.equal name, 'spicy cabbage', 'Changes to model attributes should be reactive'
        done()


    changed = true
    kimchi.set 'name', 'spicy cabbage'
    # set same value again, should not invalidate
    kimchi.set 'name', 'spicy cabbage'

  Tinytest.addAsync 'ReactiveModel - select()', (test, done) ->
    callCount = 0
    changed = false
    
    Kimchis.insert
      name: 'cabbage'
    Kimchis.insert
      name: 'raddish'

    kimchi = new Kimchi name: 'cabbage'

    Deps.autorun ->
      name = kimchi.get('name')
      callCount++
      ###
TODO: figure out why this is being called more than twice
      My hypothesis is that Tinytest clears the local collections 
      when all tests have been started but before they're all 
      done. That's why I'm testing if `name` is defined.
      ###
      if changed and name?
        test.equal callCount, 2, 'One re-select should only trigger one re-run'
        test.equal name, 'raddish', 'Selecting should be reactive'
        done()

    changed = true
    kimchi.select(name: 'raddish')
    # select same document, should not invalidate
    kimchi.select(name: 'raddish')

  Tinytest.addAsync 'ReactiveModel - inserting w/out _id', (test, done) ->

    kimchi = new Kimchi name: 'kale & cabbage'

    doc = Kimchis.findOne name: 'kale & cabbage'

    test.isUndefined(doc, 'insert() must be called to put the document in the collection')

    
    Deps.autorun ->
      name = kimchi.get('name')
      if kimchi.inserted() and name?
        test.equal name, 'kale & cabbage'
        done()

    kimchi.insert() unless kimchi.inserted()

    test.isTrue kimchi.inserted()

  Tinytest.addAsync 'ReactiveModel - inserting w/ _id', (test, done) ->

    kimchi = new Kimchi 'da best'

    doc = Kimchis.findOne 'da best'

    test.isUndefined(doc, 'insert() must be called to put the document in the collection')

    Deps.autorun ->
      _id = kimchi.get('_id')
      if kimchi.inserted() and _id?
        test.equal _id, 'da best'
        done()

    kimchi.insert() unless kimchi.inserted()

    test.isTrue kimchi.inserted()

  Tinytest.add 'ReactiveModel - defaults', (test) ->

    Kimchis.insert name: 'kimchi kimchi'

    kimchi = new Kimchi name: 'kimchi smoothie'
    kimchi2 = new Kimchi name: 'kimchi kimchi'

    kimchi.insert() unless kimchi.inserted()

    test.equal kimchi.get('fermentedForMonths'), 9
    test.equal kimchi.get('price'), 8

    test.equal kimchi2.get('fermentedForMonths'), 9
    test.equal kimchi2.get('price'), 8
    

  Tinytest.add 'ReactiveModel - remove()', (test) ->

    Kimchis.insert name: 'kimchi pancakes'

    kimchi = new Kimchi name: 'kimchi pancakes'

    test.isTrue kimchi.remove()

    count = Kimchis.find(name: 'kimchi pancakes').count()

    test.equal count, 0

  # TODO: report issue w/ Tinytest: last test takes longer on average
