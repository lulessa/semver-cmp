describe "semver-cmp", ->
  expect = require("chai").expect

  semverCmp = require("./semver-cmp")

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
      expect(semverCmp.split("1.2.3.4567")).to.deep.equal([ 1, 2, 3, "4567" ])
      expect(semverCmp.split("1.2.3.4567.89")).to.deep.equal([ 1, 2, 3, "4567.89" ])

    it "converts float or integer input to string", ->
      expect(semverCmp.split(1.2)).to.deep.equal([ 1, 2, 0 ])
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

