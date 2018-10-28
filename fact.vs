# fact.vs - tail call version of factorial
defn fact(n) {
  defn fact_aps(n, acc) {
    :n < 2 && return :acc
    fact_aps(:n - 1, :n * :acc)
  }
  fact_aps(:n, 1)
}
