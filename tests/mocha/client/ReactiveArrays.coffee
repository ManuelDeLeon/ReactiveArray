if typeof MochaWeb isnt 'undefined'
  MochaWeb.testOnly ->
    objectsAreEqual = (obj1, obj2) ->
      return false if obj1.length isnt obj2.length
      for p of obj1
        return false if obj1[p] isnt obj2[p]
      true

    describe "ReactiveArray", ->
      arr = null
      beforeEach ->
        arr = new ReactiveArray ['a', 'b']

      describe "New ViewModel", ->
        it "should have array values", ->
          chai.assert.equal arr.length, 2
          chai.assert.equal arr[0], 'a'
          chai.assert.equal arr[1], 'b'

        it "should be instance of Array", ->
          chai.assert.isTrue arr instanceof Array

      describe "push", ->
        it "should return the item", ->
          ret = arr.push 'c'
          chai.assert.equal ret, 'c'

        it "should add item to array", ->
          arr.push 'c'
          chai.assert.equal arr.length, 3
          chai.assert.equal arr[0], 'a'
          chai.assert.equal arr[1], 'b'
          chai.assert.equal arr[2], 'c'

        it "should notify", (done) ->
          Tracker.autorun (c) ->
            a = arr.list()
            if not c.firstRun
              chai.assert.equal arr[2], 'c'
              c.stop()
              done()

          arr.push 'c'

        it "should not notify when paused", (done) ->
          changed = false
          Tracker.autorun (c) ->
            a = arr.list()
            if not c.firstRun
              changed = true
              c.stop()
          arr.pause()
          arr.push 'c'
          Global.delay 15, ->
            chai.assert.isFalse changed
            done()

        it "should notify when resumed", (done) ->
          Tracker.autorun (c) ->
            a = arr.list()
            if not c.firstRun
              chai.assert.equal arr[2], 'c'
              c.stop()
              done()
          arr.pause()
          arr.push 'c'
          arr.resume()

      describe "pop", ->
        it "should return the item", ->
          ret = arr.pop()
          chai.assert.equal ret, 'b'

        it "should remove last item", ->
          arr.pop()
          chai.assert.equal arr.length, 1
          chai.assert.equal arr[0], 'a'

        it "should notify", (done) ->
          Tracker.autorun (c) ->
            a = arr.list()
            if not c.firstRun
              chai.assert.equal arr.length, 1
              chai.assert.equal arr[0], 'a'
              c.stop()
              done()

          arr.pop()

        it "should not notify when paused", (done) ->
          changed = false
          Tracker.autorun (c) ->
            a = arr.list()
            if not c.firstRun
              changed = true
              c.stop()
          arr.pause()
          arr.pop()
          Global.delay 15, ->
            chai.assert.isFalse changed
            done()

        it "should notify when resumed", (done) ->
          Tracker.autorun (c) ->
            a = arr.list()
            if not c.firstRun
              chai.assert.equal arr.length, 1
              chai.assert.equal arr[0], 'a'
              c.stop()
              done()
          arr.pause()
          arr.pop()
          arr.resume()

      describe "list", ->
        it "should work without parameters", (done) ->
          ra = new ReactiveArray()
          Tracker.autorun (c) ->
            a = ra.list()
            if not c.firstRun
              chai.assert.equal a.length, 1
              chai.assert.equal a[0], 'a'
              c.stop()
              done()
          ra.push 'a'

        it "should work with an array", (done) ->
          ra = new ReactiveArray(['a'])
          Tracker.autorun (c) ->
            a = ra.list()
            if not c.firstRun
              chai.assert.equal a.length, 2
              chai.assert.equal a[0], 'a'
              chai.assert.equal a[1], 'b'
              c.stop()
              done()
          ra.push 'b'

        it "should work with an array and a dep", (done) ->
          dep = new Tracker.Dependency()
          ra = new ReactiveArray(['a'], dep)

          Tracker.autorun (c) ->
            dep.depend()
            if not c.firstRun
              chai.assert.equal ra.length, 2
              chai.assert.equal ra[0], 'a'
              chai.assert.equal ra[1], 'b'
              c.stop()
              done()

          ra.push 'b'