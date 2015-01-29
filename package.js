Package.describe({
  name: "manuel:reactivearray",
  summary: "Reactive Array for Meteor",
  version: "1.0.1",
  git: "https://github.com/ManuelDeLeon/ReactiveArray"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');
    api.use('coffeescript');
    api.addFiles(['ReactiveArray.coffee'], 'client');
    api.export('ReactiveArray');
});
