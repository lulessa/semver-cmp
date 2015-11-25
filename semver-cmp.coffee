SemverCmpBase = require("./semver-cmp-base")
SemverCmpPre = require("./semver-cmp-pre")

module.exports =
  split: SemverCmpBase.split

  cmp: SemverCmpBase.cmp

  cmppre: SemverCmpPre.cmppre

  lt: (versionA, versionB) ->
    0 > @cmp versionA, versionB

  lte: (versionA, versionB) ->
    0 >= @cmp versionA, versionB

  eq: (versionA, versionB) ->
    0 is @cmp versionA, versionB

  gt: (versionA, versionB) ->
    0 < @cmp versionA, versionB

  gte: (versionA, versionB) ->
    0 <= @cmp versionA, versionB
