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
    return @cmppre a[3], b[3]

  cmppre: (a, b) ->
    unless a and b
    # Pre-release versions have a lower precedence than the associated normal version
      return (if a or b then (if b and not a then 1 else -1) else 0)
    stripMeta = (pre) -> pre.toString().split("+")[0]
    [ a, b ] = (stripMeta(pre).split(".") for pre in [ a, b ])
    identifier = (id) ->
      exists = id?
      exists && +id && id = +id
      [ id, exists ]
    i = 0
    while a[i]? or b[i]?
      idA = identifier a[i]
      idB = identifier b[i]
      # Compares exists first, then proper id
      for k in [1..0] when idA[k] isnt idB[k]
        return (if idA[k] > idB[k] then 1 else -1)
      i++
    return 0

  lt: (versionA, versionB) ->
    0 > @cmp versionA, versionB

  gte: (versionA, versionB) ->
    0 <= @cmp versionA, versionB
