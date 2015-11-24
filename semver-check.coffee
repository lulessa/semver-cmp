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

  compare: (a, b, comparison) ->
    a = @split a
    b = @split b
    return comparison a[0], b[0] if a[0] isnt b[0]
    return comparison a[1], b[1] if a[1] isnt b[1]
    return comparison a[2], b[2]

  lt: (versionA, versionB) ->
    @compare versionA, versionB, (a, b) -> a < b

  gte: (versionA, versionB) ->
    @compare versionA, versionB, (a, b) -> a >= b
