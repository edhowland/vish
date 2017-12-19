# call.vsh one lambda calls another
callee=->(n) { :n + 100 }
caller=->(n, fn) { %fn(:n) }
%caller(9, :callee)
