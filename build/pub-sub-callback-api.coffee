###!
# pub-sub-callback-api 1.1.1 | https://github.com/yivo/pub-sub-callback-api | MIT License
###

((factory) ->

  __root__ = 
    # The root object for Browser or Web Worker
    if typeof self is 'object' and self isnt null and self.self is self
      self

    # The root object for Server-side JavaScript Runtime
    else if typeof global is 'object' and global isnt null and global.global is global
      global

    else
      Function('return this')()

  # Asynchronous Module Definition (AMD)
  if typeof define is 'function' and typeof define.amd is 'object' and define.amd isnt null
    __root__.Callbacks = factory(__root__)
    define -> __root__.Callbacks

  # Server-side JavaScript Runtime compatible with CommonJS Module Spec
  else if typeof module is 'object' and module isnt null and typeof module.exports is 'object' and module.exports isnt null
    module.exports = factory(__root__)

  # Browser, Web Worker and the rest
  else
    __root__.Callbacks = factory(__root__)

  # No return value
  return

)((__root__) ->
  wrapIf = (fn, conditions, expected) ->
    ->
      for condition in conditions
        result = if condition.call? then condition.call(this) else this[condition]()
        return unless !!result is expected
  
      fn.apply(this, arguments)
      return
      
  VERSION: '1.1.1'
  
  included: ->
    @initializer ->
      c = @__callbacks__
      i = -3
      l = c.length
      this[c[i]](c[i+1], c[i+2]) while (i+=3) < l
      return
  
  ClassMembers:
    callback: (options, fn) ->
      if options.if? and options.unless?
        throw TypeError "[Callbacks] Both 'if' and 'unless' can't be specified at one time"
      
      if options.on? and options.once?
        throw TypeError "[Callbacks] Both 'on' and 'once' can't be specified at one time"
        
      eventtype = if options.once? then 'once' else 'on'
      eventname = options[eventtype]
      eventfn   = if options.if?
                    wrapIf(fn, [].concat(options.if), true) 
                  else if options.unless?
                    wrapIf(fn, [].concat(options.unless), false)
                  else
                    fn
        
      this::__callbacks__ = this::__callbacks__.concat([eventtype, eventname, eventfn])
      Object.freeze?(this::__callbacks__)
      this
      
  InstanceMembers:
    __callbacks__: []
)