class @ReactiveArray extends Array
  isArray = (obj) -> obj instanceof Array
  dep = null
  pause = false
  changed = ->
    dep.changed() if dep and not pause

  constructor: (p1, p2) ->
    if isArray p1
      for item in p1
        @push item
      dep = p2
    else
      dep = p1

    if not (dep instanceof Tracker.Dependency)
      dep = new Tracker.Dependency()

  list: ->
    dep.depend()
    @

  push: (item) ->
    super item
    changed()
    item

  pop: ->
    item = super()
    changed()
    item

  pause: -> pause = true
  resume: ->
    pause = false
    changed()