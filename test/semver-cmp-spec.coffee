describe "semver-cmp", ->
  expect = require("chai").expect

  semverCmp = require("../semver-cmp")

  context "#split", ->
    it "returns array with major, minor, patch version integers", ->
      expect(semverCmp.split("1.2.3")).to.deep.equal([ 1, 2, 3 ])

    it "sets patch to 0 by default", ->
      expect(semverCmp.split("1.2")).to.deep.equal([ 1, 2, 0 ])
      expect(semverCmp.split("1.2.n")).to.deep.equal([ 1, 2, 0 ])

    it "sets minor to 0 by default", ->
      expect(semverCmp.split("1")).to.deep.equal([ 1, 0, 0])
      expect(semverCmp.split("1.n")).to.deep.equal([ 1, 0, 0])

    it "passes extra versioning thru as string", ->
      expect(semverCmp.split("1.2.3-4567")).to.deep.equal([ 1, 2, 3, "4567" ])
      expect(semverCmp.split("1.2.3-4567.89")).to.deep.equal([ 1, 2, 3, "4567.89" ])

    it "converts float or integer input to string", ->
      expect(semverCmp.split(1.2)).to.deep.equal([ 1, 2, 0 ])
      expect(semverCmp.split(1.12)).to.deep.equal([ 1, 12, 0 ])
      expect(semverCmp.split(2)).to.deep.equal([ 2, 0, 0 ])

    it "throws if input cannot be converted to string", ->
      thrownError = [ TypeError, /must be string or number/ ]
      expect(-> semverCmp.split({ v: "1.2.3" })).to.throw(thrownError...)
      expect(-> semverCmp.split([ 1, 2, 3 ])).to.throw(thrownError...)
      expect(-> semverCmp.split(undefined)).to.throw(thrownError...)

  context "#lt", ->
    it "returns true when major is lower", ->
      expect(semverCmp.lt("1.2.3", "4.0.1")).to.be.true

    it "returns true when minor is lower", ->
      expect(semverCmp.lt("1.2.3", "1.4.0")).to.be.true
      expect(semverCmp.lt("1.2.3", "1.10.1")).to.be.true

    it "returns true when patch is lower", ->
      expect(semverCmp.lt("1.2.3", "1.2.4")).to.be.true
      expect(semverCmp.lt("1.2.3", "1.2.10")).to.be.true

    it "returns false when major is higher", ->
      expect(semverCmp.lt("1.0.1", "0.2.3")).to.be.false

    it "returns false when minor is higher", ->
      expect(semverCmp.lt("1.4.1", "1.2.3")).to.be.false
      expect(semverCmp.lt("1.10.1", "1.2.3")).to.be.false

    it "returns false when patch is higher", ->
      expect(semverCmp.lt("1.2.4", "1.2.3")).to.be.false
      expect(semverCmp.lt("1.2.10", "1.2.3")).to.be.false

    it "returns false when major, minor and patch are same", ->
      expect(semverCmp.lt("1.2.3", "1.2.3")).to.be.false

  context "#gte", ->
    it "returns false when patch is lower", ->
      expect(semverCmp.gte("1.2.3", "1.2.4")).to.be.false
      expect(semverCmp.gte("1.2.3", "1.2.10")).to.be.false

    it "returns false when minor is lower", ->
      expect(semverCmp.gte("1.2.3", "1.7.1")).to.be.false
      expect(semverCmp.gte("1.2.3", "1.11.1")).to.be.false
      expect(semverCmp.gte("1.10.3", "1.11.1")).to.be.false

    it "returns false when major is lower", ->
      expect(semverCmp.gte("1.2.3", "4.1.1")).to.be.false

    it "returns true when patch is higher", ->
      expect(semverCmp.gte("1.2.4", "1.2.3")).to.be.true
      expect(semverCmp.gte("1.2.10", "1.2.3")).to.be.true

    it "returns true when minor is higher", ->
      expect(semverCmp.gte("1.4.1", "1.2.3")).to.be.true
      expect(semverCmp.gte("1.10.1", "1.2.3")).to.be.true

    it "returns true when major is higher", ->
      expect(semverCmp.gte("1.1.0", "0.2.3")).to.be.true

    it "returns true when major, minor and patch are same", ->
      expect(semverCmp.gte("1.2.3", "1.2.3")).to.be.true

  context "#cmp", ->
    it "returns integer 0 when version a equals b", ->
      expect(semverCmp.cmp("1.2.3", "1.2.3")).to.equal(0)

    it "returns integer 1 when version a is higher than b", ->
      expect(semverCmp.cmp("1.4.1", "1.2.3")).to.equal(1)
      expect(semverCmp.cmp("1.10.1", "1.2.3")).to.equal(1)

    it "returns integer -1 when version a is lower than b", ->
      expect(semverCmp.cmp("1.2.3", "1.7.1")).to.equal(-1)
      expect(semverCmp.cmp("1.2.3", "1.11.1")).to.equal(-1)
      expect(semverCmp.cmp("1.10.3", "1.11.1")).to.equal(-1)

    it "gives pre-release version a lower precendence than associated normal version", ->
      expect(semverCmp.cmp("1.2.3-beta", "1.2.3")).to.equal(-1)
      expect(semverCmp.cmp("1.2.3-0.4.5", "1.2.3")).to.equal(-1)

    it "compares pre-release versions when normal versions equal", ->
      expect(semverCmp.cmp("1.0.0", "1.0.0")).to.equal(0)
      expect(semverCmp.cmp("1.0.0-alpha", "1.0.0-alpha.1")).to.equal(-1)
      expect(semverCmp.cmp("1.0.0-alpha.1", "1.0.0-alpha.beta")).to.equal(-1)
      expect(semverCmp.cmp("1.0.0-beta", "1.0.0-beta.2")).to.equal(-1)
      expect(semverCmp.cmp("1.0.0-beta.2", "1.0.0-beta.11")).to.equal(-1)
      expect(semverCmp.cmp("1.0.0-beta.11", "1.0.0-rc.1")).to.equal(-1)
      expect(semverCmp.cmp("1.0.0-rc.1", "1.0.0-beta.11")).to.equal(1)

  context "#cmppre", ->
    it "returns 0 when both parameters are undefined", ->
      expect(semverCmp.cmppre(undefined, undefined)).to.equal(0)

    it "returns 0 when both parameters are equal", ->
      expect(semverCmp.cmppre("beta.1.2.alpha", "beta.1.2.alpha")).to.equal(0)

    it "gives pre-release version a lower precendence than undefined pre-release", ->
      expect(semverCmp.cmppre("beta", undefined)).to.equal(-1)
      expect(semverCmp.cmppre("0.4.5", undefined)).to.equal(-1)
      expect(semverCmp.cmppre(undefined, "beta")).to.equal(1)

    it "ignores plus sign and metadata after it", ->
      expect(semverCmp.cmppre("alpha+001", "alpha+007")).to.equal(0)
      expect(semverCmp.cmppre("alpha+001", "beta+007")).to.equal(-1)

    it "compares each dot separated identifier from left to right until a
        difference is found", ->
      expect(semverCmp.cmppre("x.7.z.92", "x.7.z.91")).to.equal(1)
      expect(semverCmp.cmppre("x.7.z.92", "x.7.z.92")).to.equal(0)
      expect(semverCmp.cmppre("x.7.z.92", "x.8.z.92")).to.equal(-1)

    it "compares identifiers consisting of only digits numerically", ->
      expect(semverCmp.cmppre("0.11", "0.2")).to.equal(1)
      expect(semverCmp.cmppre("0.11", "0.13")).to.equal(-1)

    it "compares identifiers containing letters or hyphens lexically in ASCII
        sort order", ->
      expect(semverCmp.cmppre("beta", "alpha")).to.equal(1)
      expect(semverCmp.cmppre("beta", "rc")).to.equal(-1)

    it "gives numeric identifiers lower precedence than non-numeric identifiers", ->
      expect(semverCmp.cmppre("beta.1", "beta.gamma")).to.equal(-1)
      expect(semverCmp.cmppre("beta.1", "beta.1x")).to.equal(-1)

    it "gives a larger set of pre-release fields a higher precedence than a
        smaller set when all of the preceding identifiers are equal", ->
      expect(semverCmp.cmppre("beta.2", "beta")).to.equal(1)
      expect(semverCmp.cmppre("beta.2.alpha.4", "beta.2.alpha")).to.equal(1)

    it "runs the gauntlet", ->
      expect(semverCmp.cmppre("alpha", "alpha.1")).to.equal(-1)
      expect(semverCmp.cmppre("alpha.1", "alpha.beta")).to.equal(-1)
      expect(semverCmp.cmppre("beta", "beta.2")).to.equal(-1)
      expect(semverCmp.cmppre("beta.2", "beta.11")).to.equal(-1)
      expect(semverCmp.cmppre("beta.11", "rc.1")).to.equal(-1)
