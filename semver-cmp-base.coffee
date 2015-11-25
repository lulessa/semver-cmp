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
    return if @cmppre then @cmppre a[3], b[3] else 0
