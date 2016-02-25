((factory) ->

  # Browser and WebWorker
  root = if typeof self is 'object' && self.self is self
    self

  # Server
  else if typeof global is 'object' && global.global is global
    global

  # AMD
  if typeof define is 'function' and define.amd
    define ['yess', 'lodash', 'publisher-subscriber', 'exports'], (_, exports) ->
      root.Callbacks = factory(root, _)

  # CommonJS
  else if typeof module is 'object' && module isnt null && typeof module.exports is 'object'
    module.exports = factory(root, require('yess'), require('lodash'), require('publisher-subscriber'))

  # Browser and the rest
  else
    root.Callbacks = factory(root, root._)

  # No return value
  return

)((__root__, _) ->
  {removeAt, isString, isFunction, generateID} = _
  
  class InvalidCallback extends Error
    constructor: (fn) ->
      @name    = 'InvalidCallback'
      @message = "[Callbacks] #{fn} isn't a valid callable"
      super(@message)
      Error.captureStackTrace?(this, @name) or (@stack = new Error().stack)
  
  wrapIf = (fn, condition) ->
    ->
      ok = if isString(condition) then this[condition]() else condition.call(this)
      fn.apply(this, arguments) if ok
      return
  
  VERSION: '1.0.1'
  
  ClassMembers:
  
    callback: (arg1, arg2, arg3) ->
      if isString(arg1)
        name    = arg1
        options = arg2
        fn      = arg3
      else
        name    = "anonymous-#{generateID()}"
        options = arg1
        fn      = arg2
  
      eventType = if options.once? then 'once' else 'on'
      eventName = options[eventType]
      throw new InvalidCallback(fn) unless isFunction(fn)
      fn = wrapIf(fn, options.if) if options.if?
      @reopenArray('_4', [name, eventType, eventName, fn])
      this
  
    initializer: (arg1, arg2) ->
      if isString(arg1)
        name = arg1
        fn   = arg2
      else
        name = "anonymous-#{generateID()}"
        fn   = arg1
      throw new InvalidCallback(fn) unless isFunction(fn)
      @reopenArray('_5', [name, fn])
      this
  
    deleteInitializer: (name) ->
      ary = @reopenArray('_5')
      l   = ary.length
      i   = -2
      while (i+=2) < l
        if ary[i] is name
          removeAt(ary, i, 2)
          i -= 2
          l -= 2
      this
  
  InstanceMembers:
  
    initialize: (arg) ->
      ref1 = this['_4']
      if ref1
        i1 = -4
        l1 = ref1.length
        this[ref1[i1+1]](ref1[i1+2], ref1[i1+3]) while (i1+=4) < l1
  
      ref2 = this['_5']
      if ref2
        i2 = -1
        l2 = ref2.length
        ref2[i2].call(this, arg) while (i2+=2) < l2
      return
  
)