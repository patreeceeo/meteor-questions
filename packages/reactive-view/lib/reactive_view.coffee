
UI.registerHelper 'block', (block, modifiers..., options) ->
  View::buildBEMClassName block, null, modifiers

UI.registerHelper 'element', (block, element, modifiers..., options) ->
  View::buildBEMClassName block, element, modifiers

class Configurable

class ReactiveView
  _getConfig: (name, defaultValue) ->
    _.result(this, name) or 
      _.result(@options, name) or 
      defaultValue or
      throw "ReactiveView wants a #{name}."

  constructor: (@options = {}) ->
    view = this
    @_getConfig('template').rendered = ->
      view.templateInstance = this
    @_assignEventsToTemplate()
    @_assignHelpersToTemplate()
    @initialize(options)

  initialize: ->

  $: (selector) ->
    # @templateInstance.findAll(@buildBEMSelector(selector))
    @_getConfig('templateInstance').$(@buildEventSelector selector)

  _assignHelpersToTemplate: ->
    boundHelpers = {}
    for key, fn of @_getConfig('helpers', {})
      do =>
        localFn = fn
        boundHelpers[key] = (args...) =>
          localFn.apply this, args

    @template.helpers boundHelpers

  buildEventSelector: (selector) ->
    selector

  _assignEventsToTemplate: ->
    @template.events = {}
    for own key, value of @_getConfig('events', {})
      eventSelector = @buildEventSelector(key)
      do =>
        localFn = value
        @template.events[eventSelector] = (args...) =>
          # TODO: support strings as well as functions for callback value
          localFn.apply this, args



