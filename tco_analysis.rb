# tco_analysis.rb - TCO analyze of AST lambda nodes

class TCOAnalysis
  include ListProc
  def last_child sexp, acc=nil
    if null?(sexp)
      acc
    else
      last_child(cdr(sexp), car(sexp))
    end
  end

  def block sexp
    last_child sexp
  end
  def lambda(sexp)
    parms = self._eval(car(sexp))
    body = _eval(cadr(sexp))

#    puts "in lambda parms: #{parms.inspect} body: #{body.inspect}"
  cons(:lambda, cons(car(sexp), body))
  end

    def _eval sexp
    if null?(sexp)
      sexp
    elsif undefined?(sexp)
      NullType.new
    elsif atom?(sexp)
      sexp
    elsif list?(sexp)
      self.send(car(sexp), cdr(sexp))
    else
      error 'bad s-expression' + sexp.inspect
    end
  end

  def method_missing(message, *args)
#    puts "Got unknown method: #{message}"
cons(message, args.first)
  end
end
