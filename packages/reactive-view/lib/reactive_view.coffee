
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
# ## Example
#
# ```coffee
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
# ```
#       
class ReactiveView

  ### Public ###
  
  # Constructor
  #
  # config - an {Object} which may contain any of the extension 
  #          points documented in the {ReactiveView} overview
  constructor: (@config = {}) ->
    view = this
    @template.isRendered ?= false
    @template.rendered = ->
      debugger
      view.template.instance = this
      view.template.isRendered = true

    @viewHelper = (args...) ->
      _.defer =>
        @_cacheElementLists()
        @_getConfig('afterRendered', (->), callback: true)
          .call(this)
      undefined

    @_assignEventsToTemplate()
    @_assignHelpersToTemplate()

    @viewHelper()

    @model ?= @_getConfig('model', null, optional: true)
    @initialize(@config)

  # Override to add initialization logic to a derived
  # class
  initialize: ->

  # A shortcut for the template instance's $
  $: (selector) ->
    # `@template.instance` will be undefined if the template has
    # not rendered yet.
    @template.instance?.$(selector)

  # Another name for {ReactiveView::$}
  findAll: (selector) ->
    @$(selector)

  ### Internal ###

  _getConfig: (
    name, 
    defaultValue, 
    {
      callback: isCallback 
      optional: isOptional
    } = {}
  ) ->
    error = Error "ReactiveView wants a #{name}."
    value = 
      if isCallback
        @config[name] or @[name] or defaultValue
      else
        _.result(@config, name) or 
          _.result(this, name) or 
          defaultValue
    unless value? or isOptional
      throw error
    value

  _assignHelpersToTemplate: ->
    boundHelpers = {}
    for own key, helper of @_getConfig('helpers', {})
      view = this
      boundHelpers[key] = _.wrap helper, (helper) =>
        @viewHelper()
        helper.call(this)

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
      handler = 
        if _.isFunction(value)
          value
        else if _.isString(value)
          @_getConfig(value, null, callback: true)

      unless _.isFunction(handler)
        throw Error "ReactiveView event maps must specify 
                     handlers by method name or closure. Event '#{key}' is mapped to #{value}." 

      events[eventSelector] = _.bind(handler, this)

    @template.events events

  _cacheElementLists: ->
    @$els ?= {}
    for own key, value of @_getConfig('els', {})
      @$els[key] = @$(value)

    undefined


