class ReactiveModel

  defaults: {}

  constructor: (selector) ->
    @_dep = new Deps.Dependency

    @collection = _.result this, 'collection'

    @select(selector)

    @observation = @collection.find(selector).observe
      added: (doc) =>
        # maybe should be if doc is a supermap of selector?
        if @_insertCalled and EJSON.equals doc, selector
          @_dep.changed()
          @observation.stop()

  set: (first, second, third) ->
    if _.isObject(first)
      @_setMany first, second
    else
      @_setOne first, second, third

  _onUpsertComplete: (error, effectedCount, options) ->

  _update: (document, options = {}) ->
    callback = (error, effectedCount) =>
      @_onUpsertComplete(error, effectedCount, options)

    if @collection.findOne(@_id)? 
      @collection.update @_id, 
        $set: document, options, callback

  insert: (options = {}) ->
    @_insertCalled = true
    callback = (error, effectedCount) =>
      @_onUpsertComplete(error, effectedCount, options)
    document = _.defaults(_id: @_id, @defaults, @selector)
    @collection.insert document, callback

  _setMany: (hash, options) ->
    hash = _.omit hash, '_id'

    @_update hash, options

  _setOne: (key, value, options) ->
    hash = {}
    hash[key] = value

    @_update hash, options

  getAll: ->
    @_dep.depend()
    @collection.findOne(@_id)

  get: (key) ->
    @getAll()?[key]

  inserted: ->
    @getAll()?

  select: (newSelector) ->
    unless EJSON.equals @selector, newSelector
      @_dep.changed()
      @selector = newSelector
      @_id =
        if _.isNumber(@selector)
          "#{@selector}"
        else if _.isString(@selector)
          @selector
        else
          @collection.findOne(@selector)?._id or Random.id()
    this

  remove: ->
    @collection.remove(@_id)





