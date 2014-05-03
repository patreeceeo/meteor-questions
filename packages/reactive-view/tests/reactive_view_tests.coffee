# render and put in the document
renderToDiv = (comp) ->
  div = document.createElement "DIV"
  UI.materialize comp, div
  div

# for events to bubble an element needs to be in the DOM.
# @return {Function} call this for cleanup
addToBody = (el) ->
  document.body.appendChild el
  ->
    document.body.removeChild el

if Meteor.isClient

  Template.__define__ 'listKimchis', -> [
    HTML.UL(
      HTML.Raw("<h1>#{Spacebars.mustache @lookup 'title'}</h1>")
      HTML.Raw("<p>#{Spacebars.mustache @lookup 'description'}</p>")
      UI.Each @lookup('kimchis'), UI.block ->
        [HTML.Raw "<li class='clickme'>#{Spacebars.mustache @lookup 'name'}</li>"]
    )
  ]
    
  class KimchiView extends ReactiveView
    template: Template.listKimchis
    helpers:
      kimchis: ->
        [
          { name: 'cabbage' }
          { name: 'raddish' }
          { name: 'mystery' }
        ]

  Tinytest.add 'ReactiveView - _getConfig()', (test) ->
    class BrewView extends KimchiView
      alsoFermented: 'beer'
    class BrewView2 extends KimchiView
      alsoFermented: -> 'beer'

    view1 = new BrewView2
    view2 = new BrewView2
      alsoFermented: 'kombucha'
    view3 = new BrewView2
      alsoFermented: -> 'kombucha'

    test.equal 'beer', view1._getConfig('alsoFermented'), 
      "class defaults: prototype properties should also be considered 
      possible config values"

    test.equal 'kombucha', view2._getConfig('alsoFermented'), 
      "class defaults: values passed via constructor config object arg 
      should take precedence over prototype properties"

    test.equal 'kombucha', view3._getConfig('alsoFermented'),
      "delayed-binding: if the config value is specified as a function 
      then the return value should be used as the actual config value"

    # it should throw an error for an undefined config value
    test.throws -> view1._getConfig 'flavor'

    test.equal 'tangy', view1._getConfig('flavor', 'tangy'),
      "it should return an argued default when the config value is undefined"

  Tinytest.add 'ReactiveView - event binding', (test) ->

    eventHandled = false

    view = new KimchiView
      events:
        'click li.clickme': ->
          eventHandled = true


    div = renderToDiv Template.listKimchis
    cleanUp = addToBody div

    $(div).find('li').click()

    test.isTrue eventHandled

    cleanUp()

  Tinytest.add 'ReactiveView - helpers', (test) ->
    helperCalled = false
    view = new KimchiView
      helpers:
        title: ->
          helperCalled = true
          'Kimchis'
        description: ->
          'a tangy, spicy Korean slaw typically made with cabbage and fermented
          in jars buried in the earth for several months.'

    div = renderToDiv Template.listKimchis
    cleanUp = addToBody div

    test.equal 'Kimchis', $(div).find('h1').text(),
      "it should take an helpers config object that can be used in the template"
    test.notEqual 'Kimchis', $(div).find('p').text(),
      "regression: make sure each helper is properly mapped to its name"

    cleanUp()
    

