

class ReactiveView
  _getConfig: (name, defaultValue) ->
    _.result(@config, name) or 
      _.result(this, name) or 
      defaultValue or
      throw "ReactiveView wants a #{name}."

  constructor: (@config = {}) ->
    view = this
    @_getConfig('template').rendered = ->
      view.template.instance = this
    @_assignEventsToTemplate()
    @_assignHelpersToTemplate()
    @initialize(@config)

  initialize: ->

  $: (selector) ->
    @template.instance.$(@buildEventSelector selector)

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



