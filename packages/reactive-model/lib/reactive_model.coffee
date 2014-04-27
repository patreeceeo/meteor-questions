class ReactiveModel

  defaults: {}

  _nextIdentifier: ->
    @constructor._instanceCount++
    "#{@constructor._instanceCount}"

  constructor: (_collectionSelector) ->
    @constructor._instanceCount = 0
    @_collectionSelector =
      if _.isNumber(_collectionSelector)
        "#{_collectionSelector}"
      else
        _collectionSelector

    @collection = _.result this, 'collection'
    
    @sync()

  sync: ->
    @doc = _.defaults { _id: @_collectionSelector },
      @collection.findOne(@_collectionSelector)

  insert: (document = {}) ->
    @doc = _.defaults(_id: @_collectionSelector, document, @defaults)
    @collection.insert @doc, (error) ->
      @_created = not error?

  set: (first, second, third) ->
    if _.isObject(first)
      @_setMany first, second
    else
      @_setOne first, second, third

  _upsert: (selector, document, options) ->
    wrappedCallback = 
      (error, effectedCount) =>
        if error
          options.error?(error)
        else
          options.success?()
    if @collection.findOne(selector)? 
      @collection.update selector, $set: document, options, wrappedCallback
        
    else
      @collection.insert _.defaults(_id: selector, document), options, wrappedCallback

  _setMany: (hash, options) ->
    hash = _.omit hash, '_id'

    _.extend @doc, hash

    @_upsert @_collectionSelector, hash, options

  _setOne: (key, value, options) ->
    @doc[key] = value
    doc = _.omit @doc, '_id',

    @_upsert @_collectionSelector, doc, options

  get: (key) ->
    @doc[key]

  remove: ->
    @collection.remove(@_collectionSelector)
    @_created = false





