
/*!
 * pub-sub-callback-api 1.1.1 | https://github.com/yivo/pub-sub-callback-api | MIT License
 */

(function() {
  (function(factory) {
    var __root__;
    __root__ = typeof self === 'object' && self !== null && self.self === self ? self : typeof global === 'object' && global !== null && global.global === global ? global : Function('return this')();
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      __root__.Callbacks = factory(__root__);
      define(function() {
        return __root__.Callbacks;
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      module.exports = factory(__root__);
    } else {
      __root__.Callbacks = factory(__root__);
    }
  })(function(__root__) {
    var wrapIf;
    wrapIf = function(fn, conditions, expected) {
      return function() {
        var condition, j, len, result;
        for (j = 0, len = conditions.length; j < len; j++) {
          condition = conditions[j];
          result = condition.call != null ? condition.call(this) : this[condition]();
          if (!!result !== expected) {
            return;
          }
        }
        fn.apply(this, arguments);
      };
    };
    return {
      VERSION: '1.1.1',
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
          if ((options["if"] != null) && (options.unless != null)) {
            throw TypeError("[Callbacks] Both 'if' and 'unless' can't be specified at one time");
          }
          if ((options.on != null) && (options.once != null)) {
            throw TypeError("[Callbacks] Both 'on' and 'once' can't be specified at one time");
          }
          eventtype = options.once != null ? 'once' : 'on';
          eventname = options[eventtype];
          eventfn = options["if"] != null ? wrapIf(fn, [].concat(options["if"]), true) : options.unless != null ? wrapIf(fn, [].concat(options.unless), false) : fn;
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
