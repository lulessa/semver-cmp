// Generated by CoffeeScript 1.10.0
(function() {
  module.exports = (function() {
    return {
      split: function(version) {
        var i, ref, release, result, segments;
        if ((ref = typeof version) !== "string" && ref !== "number") {
          throw new TypeError("version must be string or number");
        }
        segments = version.toString().split("-");
        release = segments[0].split(".");
        result = (function() {
          var j, results;
          results = [];
          for (i = j = 0; j < 3; i = ++j) {
            results.push(+release[i] || 0);
          }
          return results;
        })();
        if (segments[1]) {
          result[3] = segments[1];
        }
        return result;
      },
      cmp: function(versionA, versionB) {
        var a, b, i, j;
        a = this.split(versionA);
        b = this.split(versionB);
        for (i = j = 0; j < 3; i = ++j) {
          if (a[i] !== b[i]) {
            return (a[i] > b[i] ? 1 : -1);
          }
        }
        return this.cmppre(a[3], b[3]);
      },
      cmppre: function(a, b) {
        var i, idA, idB, identifier, j, k, pre, ref, stripMeta;
        if (!(a && b)) {
          return (a || b ? (b && !a ? 1 : -1) : 0);
        }
        stripMeta = function(pre) {
          return pre.toString().split("+")[0];
        };
        ref = (function() {
          var j, len, ref, results;
          ref = [a, b];
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            pre = ref[j];
            results.push(stripMeta(pre).split("."));
          }
          return results;
        })(), a = ref[0], b = ref[1];
        identifier = function(id) {
          var exists;
          exists = id != null;
          exists && +id && (id = +id);
          return [id, exists];
        };
        i = 0;
        while ((a[i] != null) || (b[i] != null)) {
          idA = identifier(a[i]);
          idB = identifier(b[i]);
          for (k = j = 1; j >= 0; k = --j) {
            if (idA[k] !== idB[k]) {
              return (idA[k] > idB[k] ? 1 : -1);
            }
          }
          i++;
        }
        return 0;
      },
      lt: function(versionA, versionB) {
        return 0 > this.cmp(versionA, versionB);
      },
      gte: function(versionA, versionB) {
        return 0 <= this.cmp(versionA, versionB);
      }
    };
  })();

}).call(this);
