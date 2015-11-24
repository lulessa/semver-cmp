// Generated by CoffeeScript 1.10.0
(function() {
  describe("semver-cmp", function() {
    var expect, semverCheck;
    expect = require("chai").expect;
    semverCheck = require("./semver-cmp");
    context("#split", function() {
      it("returns array with major, minor, patch version integers", function() {
        return expect(semverCheck.split("1.2.3")).to.deep.equal([1, 2, 3]);
      });
      it("sets patch to 0 by default", function() {
        expect(semverCheck.split("1.2")).to.deep.equal([1, 2, 0]);
        return expect(semverCheck.split("1.2.n")).to.deep.equal([1, 2, 0]);
      });
      it("sets minor to 0 by default", function() {
        expect(semverCheck.split("1")).to.deep.equal([1, 0, 0]);
        return expect(semverCheck.split("1.n")).to.deep.equal([1, 0, 0]);
      });
      it("passes pre-release version thru as string", function() {
        expect(semverCheck.split("1.2.3-4567")).to.deep.equal([1, 2, 3, "4567"]);
        expect(semverCheck.split("1.2.3-4567.89")).to.deep.equal([1, 2, 3, "4567.89"]);
        return expect(semverCheck.split("1.2.3-alpha.89")).to.deep.equal([1, 2, 3, "alpha.89"]);
      });
      it("converts float or integer input to string", function() {
        expect(semverCheck.split(1.2)).to.deep.equal([1, 2, 0]);
        return expect(semverCheck.split(2)).to.deep.equal([2, 0, 0]);
      });
      return it("throws if input cannot be converted to string", function() {
        var ref, ref1, ref2, thrownError;
        thrownError = [TypeError, /must be string or number/];
        (ref = expect(function() {
          return semverCheck.split({
            v: "1.2.3"
          });
        }).to)["throw"].apply(ref, thrownError);
        (ref1 = expect(function() {
          return semverCheck.split([1, 2, 3]);
        }).to)["throw"].apply(ref1, thrownError);
        return (ref2 = expect(function() {
          return semverCheck.split(void 0);
        }).to)["throw"].apply(ref2, thrownError);
      });
    });
    context("#lt", function() {
      it("returns true when major is lower", function() {
        return expect(semverCheck.lt("1.2.3", "4.0.1")).to.be["true"];
      });
      it("returns true when minor is lower", function() {
        expect(semverCheck.lt("1.2.3", "1.4.0")).to.be["true"];
        return expect(semverCheck.lt("1.2.3", "1.10.1")).to.be["true"];
      });
      it("returns true when patch is lower", function() {
        expect(semverCheck.lt("1.2.3", "1.2.4")).to.be["true"];
        return expect(semverCheck.lt("1.2.3", "1.2.10")).to.be["true"];
      });
      it("returns false when major is higher", function() {
        return expect(semverCheck.lt("1.0.1", "0.2.3")).to.be["false"];
      });
      it("returns false when minor is higher", function() {
        expect(semverCheck.lt("1.4.1", "1.2.3")).to.be["false"];
        return expect(semverCheck.lt("1.10.1", "1.2.3")).to.be["false"];
      });
      it("returns false when patch is higher", function() {
        expect(semverCheck.lt("1.2.4", "1.2.3")).to.be["false"];
        return expect(semverCheck.lt("1.2.10", "1.2.3")).to.be["false"];
      });
      return it("returns false when major, minor and patch are same", function() {
        return expect(semverCheck.lt("1.2.3", "1.2.3")).to.be["false"];
      });
    });
    context("#gte", function() {
      it("returns false when patch is lower", function() {
        expect(semverCheck.gte("1.2.3", "1.2.4")).to.be["false"];
        return expect(semverCheck.gte("1.2.3", "1.2.10")).to.be["false"];
      });
      it("returns false when minor is lower", function() {
        expect(semverCheck.gte("1.2.3", "1.7.1")).to.be["false"];
        expect(semverCheck.gte("1.2.3", "1.11.1")).to.be["false"];
        return expect(semverCheck.gte("1.10.3", "1.11.1")).to.be["false"];
      });
      it("returns false when major is lower", function() {
        return expect(semverCheck.gte("1.2.3", "4.1.1")).to.be["false"];
      });
      it("returns true when patch is higher", function() {
        expect(semverCheck.gte("1.2.4", "1.2.3")).to.be["true"];
        return expect(semverCheck.gte("1.2.10", "1.2.3")).to.be["true"];
      });
      it("returns true when minor is higher", function() {
        expect(semverCheck.gte("1.4.1", "1.2.3")).to.be["true"];
        return expect(semverCheck.gte("1.10.1", "1.2.3")).to.be["true"];
      });
      it("returns true when major is higher", function() {
        return expect(semverCheck.gte("1.1.0", "0.2.3")).to.be["true"];
      });
      return it("returns true when major, minor and patch are same", function() {
        return expect(semverCheck.gte("1.2.3", "1.2.3")).to.be["true"];
      });
    });
    context("#cmp", function() {
      it("returns integer 0 when version a equals b", function() {
        return expect(semverCheck.cmp("1.2.3", "1.2.3")).to.equal(0);
      });
      it("returns integer 1 when version a is higher than b", function() {
        expect(semverCheck.cmp("1.4.1", "1.2.3")).to.equal(1);
        return expect(semverCheck.cmp("1.10.1", "1.2.3")).to.equal(1);
      });
      it("returns integer -1 when version a is lower than b", function() {
        expect(semverCheck.cmp("1.2.3", "1.7.1")).to.equal(-1);
        expect(semverCheck.cmp("1.2.3", "1.11.1")).to.equal(-1);
        return expect(semverCheck.cmp("1.10.3", "1.11.1")).to.equal(-1);
      });
      it("gives pre-release version a lower precendence than associated normal version", function() {
        expect(semverCheck.cmp("1.2.3-beta", "1.2.3")).to.equal(-1);
        return expect(semverCheck.cmp("1.2.3-0.4.5", "1.2.3")).to.equal(-1);
      });
      return it("compares pre-release versions when normal versions equal", function() {
        expect(semverCheck.cmp("1.0.0", "1.0.0")).to.equal(0);
        expect(semverCheck.cmp("1.0.0-alpha", "1.0.0-alpha.1")).to.equal(-1);
        expect(semverCheck.cmp("1.0.0-alpha.1", "1.0.0-alpha.beta")).to.equal(-1);
        expect(semverCheck.cmp("1.0.0-beta", "1.0.0-beta.2")).to.equal(-1);
        expect(semverCheck.cmp("1.0.0-beta.2", "1.0.0-beta.11")).to.equal(-1);
        expect(semverCheck.cmp("1.0.0-beta.11", "1.0.0-rc.1")).to.equal(-1);
        return expect(semverCheck.cmp("1.0.0-rc.1", "1.0.0-beta.11")).to.equal(1);
      });
    });
    return context("#cmppre", function() {
      it("returns 0 when both parameters are undefined", function() {
        return expect(semverCheck.cmppre(void 0, void 0)).to.equal(0);
      });
      it("returns 0 when both parameters are equal", function() {
        return expect(semverCheck.cmppre("beta.1.2.alpha", "beta.1.2.alpha")).to.equal(0);
      });
      it("gives pre-release version a lower precendence than undefined pre-release", function() {
        expect(semverCheck.cmppre("beta", void 0)).to.equal(-1);
        expect(semverCheck.cmppre("0.4.5", void 0)).to.equal(-1);
        return expect(semverCheck.cmppre(void 0, "beta")).to.equal(1);
      });
      it("ignores plus sign and metadata after it", function() {
        expect(semverCheck.cmppre("alpha+001", "alpha+007")).to.equal(0);
        return expect(semverCheck.cmppre("alpha+001", "beta+007")).to.equal(-1);
      });
      it("compares each dot separated identifier from left to right until a difference is found", function() {
        expect(semverCheck.cmppre("x.7.z.92", "x.7.z.91")).to.equal(1);
        expect(semverCheck.cmppre("x.7.z.92", "x.7.z.92")).to.equal(0);
        return expect(semverCheck.cmppre("x.7.z.92", "x.8.z.92")).to.equal(-1);
      });
      it("compares identifiers consisting of only digits numerically", function() {
        expect(semverCheck.cmppre("0.11", "0.2")).to.equal(1);
        return expect(semverCheck.cmppre("0.11", "0.13")).to.equal(-1);
      });
      it("compares identifiers containing letters or hyphens lexically in ASCII sort order", function() {
        expect(semverCheck.cmppre("beta", "alpha")).to.equal(1);
        return expect(semverCheck.cmppre("beta", "rc")).to.equal(-1);
      });
      it("gives numeric identifiers lower precedence than non-numeric identifiers", function() {
        expect(semverCheck.cmppre("beta.1", "beta.gamma")).to.equal(-1);
        return expect(semverCheck.cmppre("beta.1", "beta.1x")).to.equal(-1);
      });
      it("gives a larger set of pre-release fields a higher precedence than a smaller set when all of the preceding identifiers are equal", function() {
        expect(semverCheck.cmppre("beta.2", "beta")).to.equal(1);
        return expect(semverCheck.cmppre("beta.2.alpha.4", "beta.2.alpha")).to.equal(1);
      });
      return it("runs the gauntlet", function() {
        expect(semverCheck.cmppre("alpha", "alpha.1")).to.equal(-1);
        expect(semverCheck.cmppre("alpha.1", "alpha.beta")).to.equal(-1);
        expect(semverCheck.cmppre("beta", "beta.2")).to.equal(-1);
        expect(semverCheck.cmppre("beta.2", "beta.11")).to.equal(-1);
        return expect(semverCheck.cmppre("beta.11", "rc.1")).to.equal(-1);
      });
    });
  });

}).call(this);
