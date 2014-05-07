


class ReactiveModel

  ### Public ###

  # You must override `collection` with a 
  # [Meteor.Collection](http://docs.meteor.com/#meteor_collection)
  # instance.
  collection: null

  # Override `defaults` with an {Object} that contains default
  # values for the wrapped document. The default values will
  # be set in the server on construction of the model provided
  # that the document already exists in the collection, otherwise
  # the defaults will be set by {::insert}
  defaults: {}

  # Wrap the first document matched given selector in a reactive
  # model. The term "model" is used in the sense of 
  # Model-View-Controller separation of concerns in which a model
  # encapsulates data and the business rules around that data.
  #
  # selector - [a Mongo selector](http://docs.meteor.com/#selectors) ({Object} or {String})
  #
  constructor: (selector) ->
    @_dep = new Deps.Dependency

    @collection = _.result this, 'collection'

    @select(selector)

    @_update @defaults

    @observation = @collection.find(selector).observe
      added: (doc) =>
        # maybe should be if doc is a supermap of selector?
        if @_insertCalled and EJSON.equals doc, selector
          @_dep.changed()
          @observation.stop()

    @initialize?()

  # Set the value of one or multiple fields in the modeled
  # document.
  #
  # {::set} can be called two ways: one-off and 
  # bulk.
  #
  #
  # Examples
  #
  #   model.set('flavor', 'turkish');
  #   model.set({flavor: 'turkish', price: 4});
  #
  #
  # first - one-off: a {String} is the key for the field to set.
  #         bulk: an {Object} is the key/value pairs to overwrite part or all of the document with.
  # second - one-off: any value that will become the field value.
  #          bulk: {Object} options.
  # third - one-off: {Object} options.
  #
  # Returns true if changes were propagated to the database
  set: (first, second, third) ->
    if _.isObject(first)
      @_setMany first, second
    else
      @_setOne first, second, third
    this

  # Insert the wrapped document into the model's collection.
  #
  # options - an options {Object} (optional)
  #
  # Returns the unique _id of the inserted document
  insert: (options = {}) ->
    @_insertCalled = true
    document = _.defaults(_id: @_id, @selector, @defaults)
    @collection.insert document

  inset: (first, second, third) ->
    unless @inserted()
      @insert()
    @set first, second, third

  # Get the whole wrapped document.
  #
  # Returns an {Object}
  getAll: ->
    @_dep.depend()
    @collection.findOne(@_id)

  # Get one field of the wrapped document.
  #
  # key - a {String}
  #
  # Returns the value associated with `key`
  get: (key) ->
    @getAll()?[key] or 
      _.isObject(@selector) and @selector[key] or 
      undefined

  # Test whether the wrapped document has been inserted yet.
  #
  # Returns a {Boolean}
  inserted: ->
    @getAll()?

  # Wrap the first document that matches given selector, 
  # potentially changing which document is being wrapped.
  #
  # newSelector - [a Mongo selector](http://docs.meteor.com/#selectors) ({Object} or {String})
  #
  # Returns `this` 
  select: (newSelector) ->
    unless EJSON.equals @selector, newSelector
      @_dep.changed()
      @_id =
        if _.isNumber(newSelector)
          "#{newSelector}"
        else if _.isString(newSelector)
          newSelector
        else
          @collection.findOne(newSelector)?._id or Random.id()

      @selector = 
        if _.isNumber(newSelector) or _.isString(newSelector)
          _id: newSelector
        else
          newSelector
    this

  # Remove the wrapped document from the collection.
  #
  # Returns `this`
  remove: ->
    @collection.remove @_id
    this


  ### Internal ###


  _setMany: (hash, options) ->
    hash = _.omit hash, '_id'

    @_update hash, options

  _setOne: (key, value, options) ->
    hash = {}
    hash[key] = value

    @_update hash, options

  _update: (document, options = {}) ->
    if @collection.findOne(@_id)? 
      !!@collection.update @_id, 
        $set: document, options



