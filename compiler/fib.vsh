# fib.vsh - poor mans Fibonacci sequence generator
# recursively calls this block until return statement is encountered
fib={ (:n == 0 or :n == 1) && return :n; n1=:n - 1; n = :n1; x=%fib; n2=:n - 2; n=:n2; y=%fib; return :x + :y }
n=1
%fib

