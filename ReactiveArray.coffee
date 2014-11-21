class ReactiveArray extends Array
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

  array: ->
    dep.depend()
    Array.prototype.slice.call @

  list: ->
    dep.depend()
    @

  depend: ->
    dep.depend()
    @

  push: ->
    item = super
    changed()
    item

  unshift: ->
    item = super
    changed()
    item

  pop: ->
    item = super
    changed()
    item

  shift: ->
    item = super
    changed()
    item

  pause: -> pause = true
  resume: ->
    pause = false
    changed()

  remove: (valueOrPredicate) ->
    underlyingArray = @
    removedValues = []
    predicate = if typeof valueOrPredicate is "function" then valueOrPredicate else (value) -> value is valueOrPredicate
    i = 0
    while i < underlyingArray.length
      value = underlyingArray[i]
      if predicate(value)
        removedValues.push value
        underlyingArray.splice i, 1
        i--
      i++
    changed() if removedValues.length
    removedValues

  clear: ->
    @pop() while @length
    changed()
    @

  concat: ->
    ret = this.array()
    for a in arguments
      if a instanceof ReactiveArray
        ret = ret.concat a.array()
      else
        ret = ret.concat a
    new ReactiveArray ret

  indexOf: ->
    dep.depend()
    super

  join: ->
    dep.depend()
    super

  lastIndexOf: ->
    dep.depend()
    super

  reverse: ->
    super
    changed()
    @

  sort: ->
    super
    changed()
    @

  splice: ->
    ret = super
    changed()
    ret