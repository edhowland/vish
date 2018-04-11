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
def cadr(x)
  car(cdr(x))
end
  def caddr(x)
    car(cadr(x))
  end

  # start of expression action verbs
  def symbol(sexp)
    ident(sexp)
  end
  def pair(sexp)
    [self.eval(car(sexp)), self.eval(cadr(sexp)), :pushl, 2, :pushl, :mkpair, :icall].flatten

  end
  def ident(sexp)
    [:pushl,  car(sexp).to_s.to_sym]
  end
  def integer exp
    [:pushl, car(exp).to_s.to_i]
  end
  def boolean exp
    [:pushl, {'true' => true, 'false' => false}[car(exp).to_s.strip]]
  end
  def string(sexp)
    [:pushl, car(sexp).to_s]
  end
  # helper for arith expressions
  def _arith(sym, sexp)
    [self.eval(car(sexp)), self.eval(cadr(sexp)), sym].flatten
  end
  def deref(sexp)
    [:pushv, car(sexp).to_s.to_sym]
  end
  def assign(sexp)
    _arith(:assign, sexp)
  end
  def add sexp
    _arith(:add, sexp)
  end
  def sub sexp
    _arith(:sub, sexp)
  end
  def mult(sexp)
    _arith(:mult, sexp)
  end
  def div(sexp)
    _arith(:div, sexp)
  end
  def modulo(sexp)
    _arith(:mod, sexp)
  end
  def exp(sexp)
    _arith(:exp, sexp)
  end
  # equality
  def eq(sexp)
    _arith(:eq, sexp)
  end
  def neq(sexp)
    _arith(:neq, sexp)
  end
  # logical ops
  def and(sexp)
    _arith(:and, sexp)
  end
  def or(sexp)
    _arith(:or, sexp)
  end

  # main root: :program
  # A program is a list of 0 or more statements
  def statements sexp, result=[]
    if null?(sexp)
      return result
    end
    self.eval(car(sexp)) +     statements(cdr(sexp), result)
  end

  def program(sexp)
#binding.pry
    [:cls, statements(car(sexp)).flatten, :halt].flatten
  end

  def eval sexp
    if null?(sexp)
      sexp
    elsif undefined?(sexp)
      NullType.new
    elsif atom?(sexp)
      sexp
    elsif list?(sexp)
      self.send(car(sexp), cdr(sexp))
    else
#    binding.pry
      error 'bad s-expression' + sexp.inspect
    end
  end
end