# recurse.vsh - lambdas can call themselves
re=->(n, fn) { :n == 0 && return :n; %fn(:n - 1, :fn) }
%re(9, :re)
