# fact-aps.vs - Factorial using accumulator passing style
defn fact(n) {
defn fact_aps(x, acc) {
  {zero?(:x) && :acc} || fact_aps(:x - 1, :acc * :x)
}

  # Now call helper
  fact_aps(:n, 1)
}
