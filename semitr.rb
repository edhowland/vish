# semitr.rb - Given some S-Expression, return bytecode(s)

def semitr sexp
  funcs = {
    :integer => ->(e) { e.to_s.to_i },
    :boolean => ->(e) {{'true' => true, 'false' => false}[e.to_s] },
    :string => ->(e) { e.to_s }, 
    :vector => ->(e) { e }
  }
  f = funcs[car(sexp)]
#binding.pry
  f[cdr(sexp)]
end

class Seval
  def initialize
    #
  end
  def error msg
    raise RuntimeError.new msg
  end
  def car(x)
    x.key
  end
  def cdr x
    x.value
  end
  def integer exp
    car(exp).to_s.to_i
  end
  def boolean exp
    {'true' => true, 'false' => false}[car(exp).to_s]
  end
  # helper for arith expressions
  def _arith(sym, sexp)
    [sym, self.eval(car(sexp)), self.eval(cadr(sexp))]
  end
  def add sexp
    _arith(:+, sexp)
  end
  def sub sexp
    _arith(:-, sexp)
  end

  def eval sexp
    if atom?(sexp)
      sexp
    elsif list?(sexp)
      self.send(car(sexp), cdr(sexp))
    else
      error 'bad s-expression' + sexp.inspect
    end
  end
end