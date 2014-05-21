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

  helpers:
    answerers: (context) ->
      App.AnswerCollection.find _idQuestion: context._id,
        {transform: @getAnswerer}
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
