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
    view1 = new KimchiView
      alsoFermented: 'kombucha'
    view2 = new KimchiView
      alsoFermented: -> 'kombucha'
    view3 = new class extends KimchiView
      alsoFermented: 'kombucha'
    view4 = new class extends KimchiView
      alsoFermented: -> 'kombucha'

    test.equal view1._getConfig('alsoFermented'), view2._getConfig('alsoFermented')
    test.equal view2._getConfig('alsoFermented'), view3._getConfig('alsoFermented')
    test.equal view3._getConfig('alsoFermented'), view4._getConfig('alsoFermented')
    test.throws -> view1._getConfig('option2')
    test.equal 'beer', view1._getConfig('option2', 'beer')

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

