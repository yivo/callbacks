((factory) ->

  # Browser and WebWorker
  root = if typeof self is 'object' and self isnt null and self.self is self
    self

  # Server
  else if typeof global is 'object' and global isnt null and global.global is global
    global

  # AMD
  if typeof define is 'function' and typeof define.amd is 'object' and define.amd isnt null
    root.Callbacks = factory(root)
    define -> root.Callbacks

  # CommonJS
  else if typeof module is 'object' and module isnt null and
          typeof module.exports is 'object' and module.exports isnt null
    module.exports = factory(root)

  # Browser and the rest
  else
    root.Callbacks = factory(root)

  # No return value
  return

)((__root__) ->
  wrapIf = (fn, condition) ->
    ->
      passes = if condition.call? then condition.call(this) else this[condition]()
      fn.apply(this, arguments) if passes
      return
  
  VERSION: '1.1.0'
  
  included: ->
    @initializer ->
      c = @__callbacks__
      i = -3
      l = c.length
      this[c[i]](c[i+1], c[i+2]) while (i+=3) < l
      return
  
  ClassMembers:
    callback: (options, fn) ->
      eventtype = if options.once? then 'once' else 'on'
      eventname = options[eventtype]
      eventfn   = if options.if? then wrapIf(fn, options.if) else fn 
      this::__callbacks__ = this::__callbacks__.concat([eventtype, eventname, eventfn])
      Object.freeze?(this::__callbacks__)
      this
      
  InstanceMembers:
    __callbacks__: []
)