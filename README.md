# callbacks

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
