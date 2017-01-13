# pub-sub-callback-api

[![Bower](https://img.shields.io/bower/v/pub-sub-callback-api.svg)](https://github.com/yivo/pub-sub-callback-api)
[![npm](https://img.shields.io/npm/v/pub-sub-callback-api.svg)](https://www.npmjs.com/package/pub-sub-callback-api)
[![License](https://img.shields.io/github/license/yivo/pub-sub-callback-api.svg)](https://github.com/yivo/pub-sub-callback-api)
[![Dependency Status](https://img.shields.io/david/yivo/pub-sub-callback-api.svg)](https://david-dm.org/yivo/pub-sub-callback-api)
[![devDependencies Status](https://img.shields.io/david/dev/yivo/pub-sub-callback-api.svg)](https://david-dm.org/yivo/pub-sub-callback-api?type=dev)

```coffee
class Person
  @include Initializable
  @include PublisherSubscriber
  @include Callbacks
  
  constructor: ({@name, @age}) -> @initialize.apply(this, arguments)
  
  @callback on: 'change:name',               -> # do stuff
  @callback on: 'change:age', if: 'isAdult', -> # do stuff
  
  isAdult: -> @age > 18
```
