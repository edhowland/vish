# fib.vs - fibonacci w/functions
defn fib(n) { 
  :n < 2 && return :n
  fib(:n - 2) + fib(:n - 1)
}
fib(9)
