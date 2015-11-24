module.exports = do ->
  split: (version) ->
    unless typeof version in [ "string", "number" ]
      throw new TypeError("version must be string or number")
    segments = version.toString().split("-")
    release = segments[0].split(".")
    result = ((+release[i] || 0) for i in [0...3])
    result[3] = segments[1] if segments[1]
    result

  cmp: (versionA, versionB) ->
    a = @split versionA
    b = @split versionB
    for i in [0...3] when a[i] isnt b[i]
      return (if a[i] > b[i] then 1 else -1)
    # Pre-release versions have a lower precedence than the associated normal version.
    return (if b[3] and not a[3] then 1 else -1) if a[3] or b[3]
    return 0

  lt: (versionA, versionB) ->
    0 > @cmp versionA, versionB

  gte: (versionA, versionB) ->
    0 <= @cmp versionA, versionB
