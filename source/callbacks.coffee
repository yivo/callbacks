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
