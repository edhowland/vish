(call/cc (lambda(k) (*54)))
 (+ 4 (call/cc    (lambda (cont) (cont (+ 1 2)))))