# Reactive Array for Meteor

This package provides a wrapper around the Array class to make it reactive. That means you can put your array inside a Tracker.autorun or a template helper and your app will be updated when items are added or removed from the array.

## Install

```bash
meteor add manuel:reactivearray
```

## Quick Usage

### Javascript

```js
var blank = new ReactiveArray();
var names = new ReactiveArray(['Tom', 'Dick', 'Harry']);
```

## List Example

![ReactiveArray list example](https://cloud.githubusercontent.com/assets/192261/17591107/f83fce54-5fb2-11e6-8469-9a499e0c5762.png)

### Code

```html
<template name="listEx">
  <ul class="unstyled">
    {{#each names }}
    <li>
      <a class="btn listExRemove" title="Remove this name">x</a> {{ this }}
    </li>
    {{/each}}
  </ul>
  <br>
  Name: <input id="listExName" type="text"> <a class="btn" id="listExAdd">Add name to list</a>
</template>
```

```js
var arr = new ReactiveArray(['Tom', 'Dick', 'Harry']);

Template.listEx.helpers({
  names: function() {
    return arr.list();
  }
});

Template.listEx.events({
  'click #listExAdd': function() {
    arr.push($('#listExName').val());
    return $('#listExName').val('');
  },
  'click .listExRemove': function() {
    return arr.remove(this.toString());
  }
});
```

## Native methods

These functions are the reactive equivalent of the native Javascript array functions:

- `concat(value1[, value2[, ...[, valueN]]])` <br/>
  Returns a new array comprised of the array on which it is called joined with the array(s) and/or value(s) provided as arguments.
- `indexOf(searchElement[, fromIndex = 0])` <br/>
  Returns the first index at which a given element can be found in the array, or -1 if it is not present.
- `join([separator = ','])` <br/>
  Joins all elements of an array into a string
- `lastIndexOf(searchElement[, fromIndex = arr.length])` <br/>
  Returns the last index at which a given element can be found in the array, or -1 if it is not present. The array is searched backwards, starting at fromIndex.
- `pop()` <br>
  Removes the last element of an array, and returns that element
- `push(element1, ..., elementN)` <br>
  Adds new elements to the end of an array, and returns the new length
- `reverse()` <br>
  Reverses an array in place. The first array element becomes the last and the last becomes the first.
- `shift()` <br>
  Removes the first element from an array and returns that element. This method changes the length of the array.
- `sort([compareFunction])` <br>
  Sorts the elements of an array in place and returns the array.
- `splice(index, howMany[, element1[, ...[, elementN]]])` <br>
  Changes the content of an array, adding new elements while removing old elements.
- `toString()` <br>
  Returns a string representing the specified array and its elements.
- `unshift([element1[, ...[, elementN]]])` <br>
  Adds new elements to the beginning of an array and returns the new length.
  
## `.array()` method

It returns all elements as a plain Javascript array.

```js
reactiveArray.array()
```

#### Example

```js
var names = new ReactiveArray(['John']);
names.push('Jane');
names.array(); // ['John', 'Jane']
```

## `.list()` method

It returns a reactive source of the array. An array variable isn't reactive by itself, you need to execute a function with `dependency.depend()` for Meteor to recognize it as a reactive source. The `.list()` method does just that.

`.depend()` and `.list()` are synonyms. The reason for providing two methods that perform the same function is that sometimes it makes more sense to say "get me the (reactive) list of items in the array" and other times "this autorun depends on that array".

```js
reactiveArray.list()
```

#### Example

```js
var names = new ReactiveArray(['Tom', 'Dick', 'Harry']);

Template.list.helpers({
  names: function() {
    return names.list();
  }
});
```

## `.depend()` method

It returns a reactive source of the array. An array variable isn't reactive by itself, you need to execute a function with `dependency.depend()` for Meteor to recognize it as a reactive source. The `.depend()` method does just that.

`.depend()` and `.list()` are synonyms. The reason for providing two methods that perform the same function is that sometimes it makes more sense to say "get me the (reactive) list of items in the array" and other times "this autorun depends on that array".

```js
reactiveArray.depend()
````

#### Example

```js
var array = new ReactiveArray();

Tracker.autorun(function() {
  array.depend();
  if (array.length > 0) {
    return console.log("The first item is: " + array[0]);
  } else {
    return console.log("The array is empty");
  }
});

array.push("car");
```

## `.clear()` method

It removes all elements from the array.

```js
array.clear()
```

#### Example

```js
var array = new ReactiveArray(['a', 'b', 'c']);
array.clear(); // []
```
