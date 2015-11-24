module.exports = do ->
  split: (version) ->
    unless typeof version in [ "string", "number" ]
      throw new TypeError("version must be string or number")
    version = version.toString()
    segments = version.split(".")
    result = ((+segments[i] || 0) for i in [0...3])
    extras = segments[3..]
    result[3] = extras.join(".") if extras.length
    result

  cmp: (versionA, versionB) ->
    a = @split versionA
    b = @split versionB
    for i in [0...3] when a[i] isnt b[i]
      return (if a[i] > b[i] then 1 else -1)
    return 0

  lt: (versionA, versionB) ->
    0 > @cmp versionA, versionB

  gte: (versionA, versionB) ->
    0 <= @cmp versionA, versionB
