# tco_analysis.rb - TCO analyze of AST lambda nodes

class TCOAnalysis
  include ListProc
    def list(*args)
      Builtins.list(*args)
    end
  # helper functions
  def conditional?(sym)
    [:logical_and, :logical_or].member? sym
  end
    def handle_last_child(sexp)
      if null?(sexp)
        NullType.new
      # handle the last child condition
      elsif null?(cdr(sexp))
      if caar(sexp) == :block
#      puts 'found inner block'
        block(cdar(sexp))
      elsif conditional?(caar(sexp))
#        list(cons(caar(sexp), list(handle_last_child(cadar(sexp)), handle_last_child(caddar(sexp))))
        list(cons(caar(sexp), list( car(handle_last_child(cdar(sexp))), car(handle_last_child(cddar(sexp)))) ) )
        elsif caar(sexp) == :lambdacall
          cons(:tailcall, cdar(sexp))
        else
          sexp
        end
      else
        cons(car(sexp), handle_last_child(cdr(sexp)))
      end
    end

  def block sexp
    list(cons(:block, handle_last_child(sexp)))
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
