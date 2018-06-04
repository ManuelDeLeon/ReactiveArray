Package.describe({
  name: "manuel:reactivearray",
  summary: "Reactive Array for Meteor",
  version: "1.0.9",
  git: "https://github.com/ManuelDeLeon/ReactiveArray"
});

Package.onUse(function(api) {
  api.versionsFrom("METEOR@1.6.1");
  api.use(["tracker@1.1.3"]);
  api.addFiles(["ReactiveArray.js"], ["client", "server"]);
  api.export("ReactiveArray");
});
