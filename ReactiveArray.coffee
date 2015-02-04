class ReactiveArray extends Array
  isArray = (obj) -> obj instanceof Array

  constructor: (p1, p2) ->
    dep = null
    pause = false
    delayed = { }
    delay = (time, nameOrFunc, fn) ->
      func = fn || nameOrFunc
      name = nameOrFunc if fn
      d = delayed[name] if name
      Meteor.clearTimeout d if d?
      id = Meteor.setTimeout func, time
      delayed[name] = id if name

    @changed = ->
      if dep and not pause
        delay 1, 'change', ->
          dep.changed()
          
    @depend = ->
      dep.depend()
    
    if isArray p1
      for item in p1
        @push item
      dep = p2
    else
      dep = p1

    if not (dep instanceof Tracker.Dependency)
      dep = new Tracker.Dependency()

    @pause = -> pause = true
    @resume = ->
      pause = false
      @changed()

  array: ->
    @depend()
    Array.prototype.slice.call @

  list: ->
    @depend()
    @

  depend: ->
    @depend()
    @

  push: ->
    item = super
    @changed()
    item

  unshift: ->
    item = super
    @changed()
    item

  pop: ->
    item = super
    @changed()
    item

  shift: ->
    item = super
    @changed()
    item



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
    @changed() if removedValues.length
    removedValues

  clear: ->
    @pop() while @length
    @changed()
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
    @depend()
    super

  join: ->
    @depend()
    super

  lastIndexOf: ->
    @depend()
    super

  reverse: ->
    super
    @changed()
    @

  sort: ->
    super
    @changed()
    @

  splice: ->
    ret = super
    @changed()
    ret