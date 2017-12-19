# fib.vs - fibonacci w/functions
defn fib(n) { :n == 0 && return :n; :n == 1 && return :n; fib(:n - 2) + fib(:n - 1) }
fib(9)
