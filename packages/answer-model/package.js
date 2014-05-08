Package.describe({
  summary: "/* fill me in */"
});

Package.on_use(function (api, where) {
  api.use('coffeescript');
  api.use('reactive-model');
  api.add_files('lib/answer_model.coffee', ['client', 'server']);
  api.export('AnswerModel');
});

Package.on_test(function (api) {
  api.use([
          'answer-model',
          'reactive-model',
          'tinytest',
          'test-helpers',
          'coffeescript',
          'mongo-livedata'
  ]);

  api.add_files('tests/answer_model_tests.coffee', ['client', 'server']);
});
