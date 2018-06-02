ReactiveArray = function(p1, p2) {
  var _this = this;
  var dep, item, j, len, pause;
  dep = null;
  pause = false;
  _this = Array.apply(this, arguments) || this;
  _this.changed = function() {
    if (dep && !pause) {
      return dep.changed();
    }
  };
  _this.depend = function() {
    return dep.depend();
  };
  if (p1 instanceof Array || Array.isArray(p1)) {
    for (j = 0, len = p1.length; j < len; j++) {
      item = p1[j];
      _this.push(item);
    }
    dep = p2;
  } else {
    dep = p1;
  }
  if (!(dep instanceof Tracker.Dependency)) {
    dep = new Tracker.Dependency();
  }
  _this.pause = function() {
    return (pause = true);
  };
  _this.resume = function() {
    pause = false;
    return this.changed();
  };
  _this.array = function() {
    this.depend();
    return Array.prototype.slice.call(this);
  };
  _this.list = function() {
    this.depend();
    return this;
  };
  _this.push = function() {
    var item;
    item = Array.prototype.push.apply(this, arguments);
    this.changed();
    return item;
  };
  _this.unshift = function() {
    var item;
    item = Array.prototype.unshift.apply(this, arguments);
    this.changed();
    return item;
  };
  _this.pop = function() {
    var item;
    item = Array.prototype.pop.apply(this, arguments);
    this.changed();
    return item;
  };
  _this.shift = function() {
    var item;
    item = Array.prototype.shift.apply(this, arguments);
    this.changed();
    return item;
  };
  _this.remove = function(valueOrPredicate) {
    var i, predicate, removedValues, underlyingArray, value;
    underlyingArray = this;
    removedValues = [];
    predicate =
      typeof valueOrPredicate === "function"
        ? valueOrPredicate
        : function(value) {
            return value === valueOrPredicate;
          };
    i = 0;
    while (i < underlyingArray.length) {
      value = underlyingArray[i];
      if (predicate(value)) {
        removedValues.push(value);
        underlyingArray.splice(i, 1);
        i--;
      }
      i++;
    }
    return removedValues;
  };
  _this.clear = function() {
    while (this.length) {
      this.pop();
    }
    return this;
  };
  _this.concat = function() {
    var a, j, len, ret;
    ret = this.array();
    for (j = 0, len = arguments.length; j < len; j++) {
      a = arguments[j];
      if (a instanceof ReactiveArray) {
        ret = ret.concat(a.array());
      } else {
        ret = ret.concat(a);
      }
    }
    return new ReactiveArray(ret);
  };
  _this.indexOf = function() {
    this.depend();
    return Array.prototype.indexOf.apply(this, arguments);
  };
  _this.join = function() {
    this.depend();
    return Array.prototype.join.apply(this, arguments);
  };
  _this.lastIndexOf = function() {
    this.depend();
    return Array.prototype.lastIndexOf.apply(this, arguments);
  };
  _this.reverse = function() {
    Array.prototype.reverse.apply(this, arguments);
    this.changed();
    return this;
  };
  _this.sort = function() {
    Array.prototype.sort.apply(this, arguments);
    this.changed();
    return this;
  };
  _this.splice = function() {
    var ret;
    ret = Array.prototype.splice.apply(this, arguments);
    this.changed();
    return ret;
  };
  return _this;
};
