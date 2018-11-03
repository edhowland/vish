# fact-direct.vs - Direct method of factorial
defn fact(n) {
  {zero?(:n) && 1} || :n * fact(:n - 1)
}
