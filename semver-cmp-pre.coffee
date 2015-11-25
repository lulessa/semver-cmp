module.exports = do ->
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
