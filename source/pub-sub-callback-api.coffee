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
