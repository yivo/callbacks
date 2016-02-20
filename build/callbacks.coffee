((factory) ->

  # Browser and WebWorker
  root = if typeof self is 'object' && self.self is self
    self

  # Server
  else if typeof global is 'object' && global.global is global
    global

  # AMD
  if typeof define is 'function' and define.amd
    define ['lodash', 'yess', 'coffee-concerns', 'publisher-subscriber', 'exports'], (_, exports) ->
      root.Callbacks = factory(root, _)

  # CommonJS
  else if typeof module is 'object' && module isnt null && typeof module.exports is 'object'
    module.exports = factory(root, require('lodash'), require('yess'), require('coffee-concerns'), require('publisher-subscriber'))

  # Browser and the rest
  else
    root.Callbacks = factory(root, root._)

  # No return value
  return

)((__root__, _) ->
  supportsConst = do ->
    try
      eval 'const BLACKHOLE;'
      true
    catch
      false
  
  if supportsConst
    eval """
      const CALLBACKS    = '_' + _.generateID();
      const INITIALIZERS = '_' + _.generateID();
         """
  else
    eval """
      var CALLBACKS    = '_' + _.generateID();
      var INITIALIZERS = '_' + _.generateID();
         """
  
  {removeAt, isString, generateID} = _
  
  VERSION: '1.0.0'
  
  ClassMembers:
  
    callback: (arg1, arg2, arg3) ->
      if typeof arg1 is 'string'
        name    = arg1
        options = arg2
        fn      = arg3
      else
        name    = "anonymous-#{generateID()}"
        options = arg1
        fn      = arg2
  
      type = if options.once then 'once' else 'on'
      @reopenArray CALLBACKS, [name, type, options[type], fn]
      this
  
    initializer: (name, fn) ->
      if arguments.length < 2
        fn   = name
        name = "anonymous-#{generateID()}"
      @reopenArray INITIALIZERS, [name, fn]
      this
  
    deleteInitializer: (name) ->
      ary = @reopenArray(INITIALIZERS)
      l   = ary.length
      i   = -2
      while (i+=2) < l
        if ary[i] is name
          removeAt(ary, i, 2)
          i -= 2
          l -= 2
      this
  
  InstanceMembers:
  
    runInitializers: (arg) ->
      ref = this[INITIALIZERS]
      if ref
        i = -1
        l = ref.length
        ref[i].call(this, arg) while (i+=2) < l
      return
  
    bindCallbacks: ->
      ref = this[CALLBACKS]
      if ref
        l = ref.length
        i = -4
        this[ref[i+1]](ref[i+2], ref[i+3]) while (i+=4) < l
      return
  
)