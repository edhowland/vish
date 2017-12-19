# counter.vsh recursively counts up to 10
fib={ (:n == 10) && return :n; n=:n + 1; %fib }
n=1
%fib

