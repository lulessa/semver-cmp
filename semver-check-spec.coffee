expect = require("chai").expect

describe "semver-check", ->
  semverCheck = require("./semver-check")

  context "#split", ->
    it "returns array with major, minor, tiny version integers", ->
      expect(serverCheck.split("1.2.3")).to.deep.equal([ 1, 2, 3 ])

    it "sets tiny to 0 by default", ->
      expect(serverCheck.split("1.2")).to.deep.equal([ 1, 2, 0 ])
      expect(serverCheck.split("1.2.n")).to.deep.equal([ 1, 2, 0 ])

    it "sets minor to 0 by default", ->
      expect(serverCheck.split("1")).to.deep.equal([ 1, 0, 0])
      expect(serverCheck.split("1.n")).to.deep.equal([ 1, 0, 0])

    it "passes extra versioning thru as string", ->
      expect(serverCheck.split("1.2.3.4567")).to.deep.equal([ 1, 2, 3, "4567" ])
      expect(serverCheck.split("1.2.3.4567.89")).to.deep.equal([ 1, 2, 3, "4567.89" ])

    it "converts float or integer input to string", ->
      expect(serverCheck.split(1.2)).to.deep.equal([ 1, 2, 0 ])
      expect(serverCheck.split(2)).to.deep.equal([ 2, 0, 0 ])

    it "throws if input cannot be converted to string", ->
      thrownError = [ TypeError, /must be string or number/ ]
      expect(-> serverCheck.split({ v: "1.2.3" })).to.throw(thrownError...)
      expect(-> serverCheck.split([ 1, 2, 3 ])).to.throw(thrownError...)
      expect(-> serverCheck.split(undefined)).to.throw(thrownError...)

  context "#lt", ->
    it "returns true when major is lower", ->
      expect(serverCheck.lt("1.2.3", "4.0.1")).to.be.true

    it "returns true when minor is lower", ->
      expect(serverCheck.lt("1.2.3", "1.4.0")).to.be.true
      expect(serverCheck.lt("1.2.3", "1.10.1")).to.be.true

    it "returns true when tiny is lower", ->
      expect(serverCheck.lt("1.2.3", "1.2.4")).to.be.true
      expect(serverCheck.lt("1.2.3", "1.2.10")).to.be.true

    it "returns false when major is higher", ->
      expect(serverCheck.lt("1.0.1", "0.2.3")).to.be.false

    it "returns false when minor is higher", ->
      expect(serverCheck.lt("1.4.1", "1.2.3")).to.be.false
      expect(serverCheck.lt("1.10.1", "1.2.3")).to.be.false

    it "returns false when tiny is higher", ->
      expect(serverCheck.lt("1.2.4", "1.2.3")).to.be.false
      expect(serverCheck.lt("1.2.10", "1.2.3")).to.be.false

    it "returns false when major, minor and tiny are same", ->
      expect(serverCheck.lt("1.2.3", "1.2.3")).to.be.false

  context "#gte", ->
    it "returns false when tiny is lower", ->
      expect(serverCheck.gte("1.2.3", "1.2.4")).to.be.false
      expect(serverCheck.gte("1.2.3", "1.2.10")).to.be.false

    it "returns false when minor is lower", ->
      expect(serverCheck.gte("1.2.3", "1.7.1")).to.be.false
      expect(serverCheck.gte("1.2.3", "1.11.1")).to.be.false
      expect(serverCheck.gte("1.10.3", "1.11.1")).to.be.false

    it "returns false when major is lower", ->
      expect(serverCheck.gte("1.2.3", "4.1.1")).to.be.false

    it "returns true when tiny is higher", ->
      expect(serverCheck.gte("1.2.4", "1.2.3")).to.be.true
      expect(serverCheck.gte("1.2.10", "1.2.3")).to.be.true

    it "returns true when minor is higher", ->
      expect(serverCheck.gte("1.4.1", "1.2.3")).to.be.true
      expect(serverCheck.gte("1.10.1", "1.2.3")).to.be.true

    it "returns true when major is higher", ->
      expect(serverCheck.gte("1.1.0", "0.2.3")).to.be.true

    it "returns true when major, minor and tiny are same", ->
      expect(serverCheck.gte("1.2.3", "1.2.3")).to.be.true

  context "#compare", ->
    it "splits versions and compares according to comparison callback", ->
      equals = (a, b) -> a is b
      expect(serverCheck.compare("1.2.3", "1.2.3", equals)).to.be.true
      expect(serverCheck.compare("1.0.0", "1.2.3", equals)).to.be.false
      expect(serverCheck.compare("1.0.0", "0.1.1", equals)).to.be.false

    it "throws when comparison argument is not a function", ->
      expect(-> serverCheck.compare("1.2.3", "1.2.3")).to.throw()

