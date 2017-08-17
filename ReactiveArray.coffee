class ReactiveArray extends Array
  isArray = (obj) -> obj instanceof Array or Array.isArray(obj)

  constructor: (p1, p2) ->
    dep = null
    pause = false

    @changed = ->
      if dep and not pause
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
    removedValues

  clear: ->
    @pop() while @length
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