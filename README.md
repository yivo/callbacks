# callbacks

```coffee
class Base
  @include Callbacks
  @include PublisherSubscriber
  constructor: (params) -> @initialize(params)

class Person extends Base
  @initializer 'defaults', ->
    @name = 'Yaroslav'

  @callback on: 'change:name', -> # do stuff

  @callback on: 'change:age', if: (-> @age > 18), -> # do stuff
```
