#TODO: consider whether to create individual question 
#      view/template.

class App.ListQuestionsView extends ReactiveView
  template: Template.listQuestions

  els:
    masonry: '.js-masonry'
    questionWrapper: '.js-question'
    question: '.js-question .u-isActionable'

  columnWidth: '24rem'

  getAnswerer: (doc) ->
    _idUser: doc._idUser
    profilePicture: Accounts.ui.profilePicture(doc._idUser)

  answerCount: (_idQuestion, options = {}) ->
    App.AnswerCollection.find _idQuestion: _idQuestion, options
      .count()

  helpers:
    answerers: (context) ->
      App.AnswerCollection.find _idQuestion: context._id,
        { transform: @getAnswerer, limit: 5 }
    answerCount: (context) ->
      @answerCount context._id

    questions: ->
      cursor = App.QuestionCollection.find()
      if cursor.count() > 0
        _.defer =>
          # TODO: figure out how to put this logic into a separate
          #       callback
          if @$els.masonry > []
            width = @_getConfig('columnWidth')
            @$els.questionWrapper.width(width)

            @masonry?.destroy()

            @masonry = new Masonry @$els.masonry[0],
              itemSelector: '.js-question'

      cursor
  initialize: ->
    @_added ?= {}
    App.AnswerCollection.find().observe
      added: (doc) =>
        $el = @$("[data-id=#{doc._idQuestion}]")
        $el.addClass "u-flashIn"
        _.defer ->
          $el.addClass "u-flashOut"
        _.delay (->
          $el.removeClass "u-flashIn"
        ), 500
        _.delay (->
          $el.removeClass "u-flashIn u-flashOut"
        ), 2000


