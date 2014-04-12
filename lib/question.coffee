
this.App = 
  addAnswer: (text, _idQuestion) ->
    _idQuestion = "#{_idQuestion}"
    App.AnswerCollection.insert
      answer: text
      _idQuestion: _idQuestion
      


class App.Model

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
    
    # TODO: figure out why this test lies initially
    @collection = _.result this, 'collection'
    unless @collection.findOne(@_collectionSelector)?
      @doc = 
        if _.isString @_collectionSelector
          _.defaults _id: @_collectionSelector, @defaults
        else
          _.defaults _id: @_nextIdentifier(), @_collectionSelector, @defaults
      @collection.insert @doc, ->

  set: (first, second, third) ->
    if _.isObject(first)
      @_setMany first, second
    else
      @_setOne first, second, third

  _setMany: (hash, options) ->
    for own key, value of hash
      @_setOne key, value, options

  _setOne: (key, value, options) ->
    partial = {}
    partial["#{key}"] = value
    @collection.update @_collectionSelector, $set: partial

  get: (key) ->
    @collection.findOne(@_collectionSelector)?[key]




