# fib_l.vs - w/lambdas
fib=->(n, fn) { :n == 0 && return :n; :n == 1 && return :n; %fn(:n - 2, :fn) + %fn(:n - 1, :fn) }
%fib(9, :fib)
