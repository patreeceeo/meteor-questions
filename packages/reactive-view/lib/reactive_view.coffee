
# A View class that serves as a thin wrapper around a Meteor
# template object, providing a cleaner, DRYer interface (and one
# more familiar to those coming from an MVC framework) without
# getting in the way or interfering with Meteor's reactivity.
#
# {ReactiveView} offers the following extension points to derived
# classes:
# template - a [Meteor template object](http://docs.meteor.com/#templates_api)
# afterRendered - a callback, will be called immediately if the
#                 template has already rendered
# helpers - [template helpers](http://docs.meteor.com/#template_helpers)
# els - an {Object} mapping names to DOM selector {String}s, a 
#       corresponding mapping will be made available under the 
#       `$els` property using jQuery arrays in place of the DOM 
#       selector {String}s.
# events - Like [template events](http://docs.meteor.com/#template_events). 
#          Additional features: the event string can contain a 
#          name from the `els` object instead of the corresponding
#          DOM selector {String} (see Examples). Like with
#          Backbone.View, the names ({String}s) of instance 
#          methods may be used instead of actual {Function}s.
#
# Examples
#
#   class GameView extends ReactiveView
#     template: Template.game
#     els: 
#       board: '.js-gb'
#       playersLetters: '.js-gbletters'
#       scoreboard: '#score'
#     events:
#       'click board': 'tryMove'
#       'keypress board': (event) ->
#         if enterKeyPress(event)
#           @tryMove(event)
#       
class ReactiveView

  ### Public ###
  
  # Constructor
  #
  # config - an {Object} which may contain any of the extension 
  #          points documented in the {ReactiveView} overview
  constructor: (@config = {}) ->
    sharedARLogic = =>
      @_cacheElementLists()
      @_getConfig('afterRendered', (->), callback: true)
        .call(this)

    view = this
    @template.isRendered ?= false
    @_getConfig('template').rendered = (args...) ->
      view.template.instance = this
      view.template.isRendered = true
      sharedARLogic()

    @_assignEventsToTemplate()
    @_assignHelpersToTemplate()

    _.defer ->
      sharedARLogic() if view.template.isRendered

    @initialize(@config)

  # Override to add initialization logic to a derived
  # class
  initialize: ->

  # A shortcut for the template instance's $
  $: (selector) ->
    @template.instance.$(selector)

  # Another name for {ReactiveView::$}
  findAll: (selector) ->
    @$(selector)

  ### Internal ###

  _getConfig: (name, defaultValue, {callback: isCallback} = {}) ->
    error = Error "ReactiveView wants a #{name}."
    if isCallback
      @config[name] or @[name] or defaultValue or throw error
    else
      _.result(@config, name) or 
        _.result(this, name) or 
        defaultValue or
        throw error

  _assignHelpersToTemplate: ->
    boundHelpers = {}
    for key, fn of @_getConfig('helpers', {})
      do =>
        localFn = fn
        boundHelpers[key] = (args...) =>
          localFn.apply this, args

    @template.helpers boundHelpers

  _buildEventSelector: (selector) ->
    els = @_getConfig('els', {})
    [eventName, rest...] = selector.split RegExp '\\s+'
    elsKey = rest.join(' ')
    "#{eventName} #{els[elsKey] or elsKey}"

  _assignEventsToTemplate: ->
    events = {}
    for own key, value of @_getConfig('events', {})
      eventSelector = @_buildEventSelector(key)
      do =>
        localFn = value
        view = this
        events[eventSelector] = (args...) ->
          # TODO: support strings as well as functions for callback value
          localFn.apply view, args

    @template.events events

  _cacheElementLists: ->
    @$els ?= {}
    for own key, value of @_getConfig('els', {})
      @$els[key] = @$(value)

    undefined


