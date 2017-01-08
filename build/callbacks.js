(function() {
  (function(factory) {
    var root;
    root = typeof self === 'object' && self !== null && self.self === self ? self : typeof global === 'object' && global !== null && global.global === global ? global : void 0;
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      root.Callbacks = factory(root);
      define(function() {
        return root.Callbacks;
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      module.exports = factory(root);
    } else {
      root.Callbacks = factory(root);
    }
  })(function(__root__) {
    var wrapIf;
    wrapIf = function(fn, condition) {
      return function() {
        var passes;
        passes = condition.call != null ? condition.call(this) : this[condition]();
        if (passes) {
          fn.apply(this, arguments);
        }
      };
    };
    return {
      VERSION: '1.1.0',
      included: function() {
        return this.initializer(function() {
          var c, i, l;
          c = this.__callbacks__;
          i = -3;
          l = c.length;
          while ((i += 3) < l) {
            this[c[i]](c[i + 1], c[i + 2]);
          }
        });
      },
      ClassMembers: {
        callback: function(options, fn) {
          var eventfn, eventname, eventtype;
          eventtype = options.once != null ? 'once' : 'on';
          eventname = options[eventtype];
          eventfn = options["if"] != null ? wrapIf(fn, options["if"]) : fn;
          this.prototype.__callbacks__ = this.prototype.__callbacks__.concat([eventtype, eventname, eventfn]);
          if (typeof Object.freeze === "function") {
            Object.freeze(this.prototype.__callbacks__);
          }
          return this;
        }
      },
      InstanceMembers: {
        __callbacks__: []
      }
    };
  });

}).call(this);
