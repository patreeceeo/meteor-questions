
Meteor.methods
  seedDatabase: ->
    QuestionCollection.insert
      text: "What would you do for a klondike bar?"
