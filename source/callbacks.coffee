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

VERSION: '1.0.0'

ClassMembers:

  callback: (name, options, fn) ->
    type = if options.once then 'once' else 'on'
    @reopenArray CALLBACKS, [name, type, options[type], fn]
    this

  initializer: (name, fn) ->
    if arguments.length < 2
      fn   = name
      name = 'anonymous'
    @reopenArray INITIALIZERS, [name, fn]
    this

  deleteInitializer: (name) ->
    ary = @reopenArray(INITIALIZERS)
    l   = ary.length
    i   = -2
    while (i+=2) < l
      if ary[i] is name
       _.removeAt(ary, i, 2)
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
