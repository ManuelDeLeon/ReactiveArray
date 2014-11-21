Package.describe({
  summary: "Reactive Array for Meteor",
  version: "1.0.0",
  git: "https://github.com/ManuelDeLeon/ReactiveArray"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.2.2');
    api.use('coffeescript', ['client', 'server']);
    api.addFiles(['ReactiveArray.coffee'], 'client');
    api.export('ReactiveArray');
});
