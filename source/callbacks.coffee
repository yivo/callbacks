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
    @reopenArray(CALLBACKS, [name, eventType, eventName, fn])
    this

  initializer: (arg1, arg2) ->
    if isString(arg1)
      name = arg1
      fn   = arg2
    else
      name = "anonymous-#{generateID()}"
      fn   = arg1
    throw new InvalidCallback(fn) unless isFunction(fn)
    @reopenArray(INITIALIZERS, [name, fn])
    this

  finalizer: (fn) ->
    @callback(on: 'destroy', fn)

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

  initialize: (arg) ->
    ref1 = this[CALLBACKS]
    if ref1
      i1 = -4
      l1 = ref1.length
      this[ref1[i1+1]](ref1[i1+2], ref1[i1+3]) while (i1+=4) < l1

    ref2 = this[INITIALIZERS]
    if ref2
      i2 = -1
      l2 = ref2.length
      ref2[i2].call(this, arg) while (i2+=2) < l2
    return
