# semitr.rb - Given some S-Expression, return bytecode(s)

def semitr sexp
  funcs = {
    :integer => ->(e) { e.to_s.to_i },
    :boolean => ->(e) {{'true' => true, 'false' => false}[e.to_s] },
    :string => ->(e) { e.to_s }, 
    :vector => ->(e) { e }
  }
  f = funcs[car(sexp)]
  f[cdr(sexp)]
end

class Seval
  def initialize
    #
  end
  def error msg
    raise RuntimeError.new msg
  end
def length(sexp, result=0)
  return result if null?(sexp)
  1 + length(cdr(sexp), result)
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
  def _vector(sexp, result=[])
    if null?(sexp)
      return result
    end
    (self.eval(car(sexp)) + _vector(cdr(sexp), result)) 
  end
  def vector(sexp)
    result = _vector(sexp)
    result << :pushl
    result << (result.length / 2)
    result + [:pushl, :mkvector, :icall]
  end
  def _args(sexp)
    args = _vector(cdr(sexp))
    args_length = length(cdr(sexp))
    args + [:pushl, args_length]
  end
  def _object(sexp, result=[])
    if null?(sexp)
      return result
    end
    (self.eval(car(sexp)) + _object(cdr(sexp), result))#.flatten
  end
  def object(sexp)
    result = _object(sexp)
    result << :pushl
    result << length(sexp)
    result << :pushl
    result << :mkobject
    result + [:icall]
  end
  def symbol(sexp)
    ident(sexp)
  end
  def pair(sexp)
    self.eval(car(sexp)) +  self.eval(cadr(sexp)) + [:pushl, 2, :pushl, :mkpair, :icall]
  end
  def ident(sexp)
    [:pushl,  car(sexp).to_s.to_sym]
  end
  def integer sexp
    [:pushl, car(sexp).to_s.to_i]
  end
  def boolean exp
    [:pushl, {'true' => true, 'false' => false}[car(exp).to_s.strip]]
  end
  def string(sexp)
    [:pushl, car(sexp).to_s]
  end
  # helper for arith expressions
  def _arith(sym, sexp)
    self.eval(car(sexp)) + self.eval(cadr(sexp)) + [sym]
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
  # Quotation: Just push the actual AST subtree onto  the stack
  def quote(sexp)
    [:pushl, sexp]
  end

  # a lambda actually returns a array of a single lambda (or Proc)
  # This gets filtered in the next stage

  def _to_a(sexp, result=[])
    if null?(sexp)
      return result
    end
    ident = self.eval(car(sexp))
    sym = ident.last.to_s.to_sym
     [sym] + _to_a(cdr(sexp), result)
  end
  def parmlist(sexp)
#puts "parmlist: #{sexp.inspect}"
    result = _to_a(sexp)
    count = result.length
    result = result.reverse.reduce([]) {|i,j|i + [:pushl, j, :swp, :assign] }
    result
  end
  def lambda(sexp)
#puts "lambda: #{sexp.inspect}"
    parms = self.eval(car(sexp))
    body = self.eval(cadr(sexp))
    [:pushl, parms, :pushl, body, :pushl, 2, :pushl, :_mklambda, :icall]
  end
  # a Funcall is a function name and a list of expressions
  def funcall(sexp)
    _args(sexp) + [:pushl,  car(sexp).to_s.to_sym, :icall]
  end

  # lambda call - deref symbol which should be a NambdaType. then :ncall
  def lambdacall(sexp)
    _args(sexp) + [:pushv, car(sexp).to_s.to_sym, :ncall] 
  end

  # A block is a bunch of statements
  def block(sexp)
    statements(sexp)
  end
  # main root: :program
  # A program is a list of 0 or more statements
  def statements sexp, result=[]
    if null?(sexp)
      return result
    end
    self.eval(car(sexp)) +     statements(cdr(sexp), result)
  end
  # The empty case
  def ignore(sexp)
    []
  end

  def program(sexp)
    [:cls] +  statements(car(sexp)) + [:halt]
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
      error 'bad s-expression' + sexp.inspect
    end
  end
end