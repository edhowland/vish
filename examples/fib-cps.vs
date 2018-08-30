# fib-cps.vs - continuation passing style of fib(n)
defn fib(n) {
  defn fib_cps(n, k) {
    zero?(:n) && return k(0, 1)
    :n == 1 && return k(0, 1)
  fib_cps(:n - 1, ->(x, y) { k(:y, :x + :y) })

  }
  fib_cps(:n, ->(x, y) { :x + :y })
}
