(function() {
  (function(factory) {
    var root;
    root = typeof self === 'object' && self.self === self ? self : typeof global === 'object' && global.global === global ? global : void 0;
    if (typeof define === 'function' && define.amd) {
      define(['lodash', 'yess', 'coffee-concerns', 'publisher-subscriber', 'exports'], function(_, exports) {
        return root.Callbacks = factory(root, _);
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object') {
      module.exports = factory(root, require('lodash'), require('yess'), require('coffee-concerns'), require('publisher-subscriber'));
    } else {
      root.Callbacks = factory(root, root._);
    }
  })(function(__root__, _) {
    var removeAt, supportsConst;
    supportsConst = (function() {
      try {
        eval('const BLACKHOLE;');
        return true;
      } catch (_error) {
        return false;
      }
    })();
    if (supportsConst) {
      eval("const CALLBACKS    = '_' + _.generateID();\nconst INITIALIZERS = '_' + _.generateID();");
    } else {
      eval("var CALLBACKS    = '_' + _.generateID();\nvar INITIALIZERS = '_' + _.generateID();");
    }
    removeAt = _.removeAt;
    return {
      VERSION: '1.0.0',
      ClassMembers: {
        callback: function(name, options, fn) {
          var type;
          type = options.once ? 'once' : 'on';
          this.reopenArray(CALLBACKS, [name, type, options[type], fn]);
          return this;
        },
        initializer: function(name, fn) {
          if (arguments.length < 2) {
            fn = name;
            name = 'anonymous';
          }
          this.reopenArray(INITIALIZERS, [name, fn]);
          return this;
        },
        deleteInitializer: function(name) {
          var ary, i, l;
          ary = this.reopenArray(INITIALIZERS);
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
        runInitializers: function(arg) {
          var i, l, ref;
          ref = this[INITIALIZERS];
          if (ref) {
            i = -1;
            l = ref.length;
            while ((i += 2) < l) {
              ref[i].call(this, arg);
            }
          }
        },
        bindCallbacks: function() {
          var i, l, ref;
          ref = this[CALLBACKS];
          if (ref) {
            l = ref.length;
            i = -4;
            while ((i += 4) < l) {
              this[ref[i + 1]](ref[i + 2], ref[i + 3]);
            }
          }
        }
      }
    };
  });

}).call(this);
