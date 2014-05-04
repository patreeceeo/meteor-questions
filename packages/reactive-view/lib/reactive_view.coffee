

class ReactiveView
  _getConfig: (name, defaultValue, {callback: isCallback} = {}) ->
    error = Error "ReactiveView wants a #{name}."
    if isCallback
      @config[name] or @[name] or defaultValue or throw error
    else
      _.result(@config, name) or 
        _.result(this, name) or 
        defaultValue or
        throw error
  constructor: (@config = {}) ->
    view = this
    # view.template.isRendered = false
    @_getConfig('template').rendered = (args...) ->
      view.template.isRendered = true
      view.template.instance = this
      view._cacheElementLists()
      view._getConfig('afterRendered', ->)
        .call(view)
    @_assignEventsToTemplate()
    @_assignHelpersToTemplate()
    _.defer ->
      if view.template.isRendered
        view._cacheElementLists()
        view._getConfig('afterRendered', (->), callback: true)
          .call(view)
    @initialize(@config)

  initialize: ->

  $: (selector) ->
    @template.instance.$(selector)

  findAll: (selector) ->
    @$(selector)

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
    @template.events = {}
    for own key, value of @_getConfig('events', {})
      eventSelector = @_buildEventSelector(key)
      do =>
        localFn = value
        view = this
        @template.events[eventSelector] = (args...) ->
          # TODO: support strings as well as functions for callback value
          localFn.apply view, args

    undefined


  _cacheElementLists: ->
    @$els ?= {}
    for own key, value of @_getConfig('els', {})
      @$els[key] = @$(value)

    undefined


