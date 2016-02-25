(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  (function(factory) {
    var root;
    root = typeof self === 'object' && self.self === self ? self : typeof global === 'object' && global.global === global ? global : void 0;
    if (typeof define === 'function' && define.amd) {
      define(['yess', 'lodash', 'publisher-subscriber', 'exports'], function(_, exports) {
        return root.Callbacks = factory(root, _);
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object') {
      module.exports = factory(root, require('yess'), require('lodash'), require('publisher-subscriber'));
    } else {
      root.Callbacks = factory(root, root._);
    }
  })(function(__root__, _) {
    var InvalidCallback, generateID, isFunction, isString, removeAt, wrapIf;
    removeAt = _.removeAt, isString = _.isString, isFunction = _.isFunction, generateID = _.generateID;
    InvalidCallback = (function(superClass) {
      extend(InvalidCallback, superClass);

      function InvalidCallback(fn) {
        this.name = 'InvalidCallback';
        this.message = "[Callbacks] " + fn + " isn't a valid callable";
        InvalidCallback.__super__.constructor.call(this, this.message);
        (typeof Error.captureStackTrace === "function" ? Error.captureStackTrace(this, this.name) : void 0) || (this.stack = new Error().stack);
      }

      return InvalidCallback;

    })(Error);
    wrapIf = function(fn, condition) {
      return function() {
        var ok;
        ok = isString(condition) ? this[condition]() : condition.call(this);
        if (ok) {
          fn.apply(this, arguments);
        }
      };
    };
    return {
      VERSION: '1.0.1',
      ClassMembers: {
        callback: function(arg1, arg2, arg3) {
          var eventName, eventType, fn, name, options;
          if (isString(arg1)) {
            name = arg1;
            options = arg2;
            fn = arg3;
          } else {
            name = "anonymous-" + (generateID());
            options = arg1;
            fn = arg2;
          }
          eventType = options.once != null ? 'once' : 'on';
          eventName = options[eventType];
          if (!isFunction(fn)) {
            throw new InvalidCallback(fn);
          }
          if (options["if"] != null) {
            fn = wrapIf(fn, options["if"]);
          }
          this.reopenArray('_4', [name, eventType, eventName, fn]);
          return this;
        },
        initializer: function(arg1, arg2) {
          var fn, name;
          if (isString(arg1)) {
            name = arg1;
            fn = arg2;
          } else {
            name = "anonymous-" + (generateID());
            fn = arg1;
          }
          if (!isFunction(fn)) {
            throw new InvalidCallback(fn);
          }
          this.reopenArray('_5', [name, fn]);
          return this;
        },
        deleteInitializer: function(name) {
          var ary, i, l;
          ary = this.reopenArray('_5');
          l = ary.length;
          i = -2;
          while ((i += 2) < l) {
            if (ary[i] === name) {
              removeAt(ary, i, 2);
              i -= 2;
              l -= 2;
            }
          }
          return this;
        }
      },
      InstanceMembers: {
        initialize: function(arg) {
          var i1, i2, l1, l2, ref1, ref2;
          ref1 = this['_4'];
          if (ref1) {
            i1 = -4;
            l1 = ref1.length;
            while ((i1 += 4) < l1) {
              this[ref1[i1 + 1]](ref1[i1 + 2], ref1[i1 + 3]);
            }
          }
          ref2 = this['_5'];
          if (ref2) {
            i2 = -1;
            l2 = ref2.length;
            while ((i2 += 2) < l2) {
              ref2[i2].call(this, arg);
            }
          }
        }
      }
    };
  });

}).call(this);
