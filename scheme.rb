# scheme.rb - Scheme eval in ruby

def seval_combo(sexp)
#binding.pry
  l = seval(cadr(sexp))
  r = seval(caddr(sexp))
  if car(sexp) == :add
    l + r
  else
    raise RuntimeError.new 'invalid procedure: ' + car(sexp)
  end
end

def seval sexp
  if atom?(sexp)
    sexp
  elsif list?(sexp)
    seval_combo(sexp)
  else
    raise RuntimeError.new 'invalid expression: ' + sexp.inspect
  end
end
