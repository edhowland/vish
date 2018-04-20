# semitr.rb - Given some S-Expression, return bytecode(s)

def ife
  "defn ife(p,c,a) { {%p && %c} || %a }"
end



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

def rbevalstr(string)
  Kernel.eval('"' + string + '"')
end
class BreakStop
  def initialize index, loc
    @index = index
    @loc = loc
  end
  attr_reader :loc
  attr_accessor :index
  def to_offset
    @loc - @index
  end
end


class Seval
  include ListProc

  def initialize
    @named_lambdas = {}
    @_saved_incr = ->() {0}
    @incr = @_saved_incr
  end
  attr_accessor :incr
  attr_reader :named_lambdas
  def _named_lambdas!(sexp)

    @named_lambdas[cadr(car(sexp)).to_s.to_sym] = true
  end
  def pump_incr
    @incr = ->() { @incr = @_saved_incr; 1 }
  end
  def error msg
    raise RuntimeError.new msg
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
    args_length = length(cdr(sexp)) + @incr[]
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
#  def null(sexp)
#    [:pushl, 0, :pushl, :mknull, :icall]
#  end
  def integer sexp
    [:pushl, car(sexp).to_s.to_i]
  end
  def boolean exp
    [:pushl, {'true' => true, 'false' => false}[car(exp).to_s.strip]]
  end
  # String interpolation
  def strtok(sexp)
    car(sexp).to_s
  end
  def escape_seq(sexp)
    rbevalstr(car(sexp).to_s)
  end
  def __str_collect(sexp)
    if null?(sexp)
      ''
    else
     self.eval(car(sexp)) + __str_collect(cdr(sexp))
    end
  end
  def string_intp(sexp)
    [:pushl, __str_collect(sexp)]
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
if car(cadr(sexp)) == :lambda
    _named_lambdas!(sexp)
end
    _arith(:assign, sexp)
  end

  # Arith expressions
  def unary_negation(sexp)
    self.eval(sexp) + [:negate]
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
  # comparison
  def less(sexp)
    _arith(:less, sexp)
  end
  def greater(sexp)
    _arith(:greater, sexp)
  end
  def lte(sexp)
    _arith(:lte, sexp)
  end
  def gte(sexp)
    _arith(:gte, sexp)
  end
  # logical ops
  def unary_inversion(sexp)
    self.eval(sexp) + [:not]
  end
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
  # control flow
  # Pipelines
  # A pipe is just a concat of its 2 statements. The stack is shared between
  # each statement
  def pipe(sexp)
    self.eval(car(sexp)) + instance_exec {pump_incr; self.eval(cadr(sexp)) }
  end
  #
  # _cedent(sexp) - evaluates sexp, computes length to jump over, returns as
  # first element
  def _cedent(sexp)
    iter = self.eval(sexp)
    [iter.length + 1] + iter
  end
  def logical_and(sexp)
    self.eval(car(sexp)) + [:jmprf] + _cedent(cadr(sexp))
  end
def logical_or(sexp)
      self.eval(car(sexp)) + [:jmprt] + _cedent(cadr(sexp))
end
  # compute branch relative locations
  # __loopb block - compute relative jump targets past end of block.
  # Handles inner loops and inner/inner/inner loops.
  def __loopb(&blk)
    codes = yield
    len = codes.length * (-1)
    result = codes + [:jmpr, len]
    if result.any? {|e| e == BreakStop }
      outside = result.length
      result = result.map {|e| e == BreakStop ? e.new(0, outside) : e }
      result.each_with_index {|e, i| e.class == BreakStop ? e.index = i : e }
      result.map! {|e| e.class == BreakStop ? e.to_offset : e }
    end
    result
  end
  def loop(sexp)
#    raise CompileError.new 'Loop not yet implemented'
    __loopb { self.eval(sexp) }
  end
  def _return(sexp)
    self.eval(sexp) + [:fret]
  end
  def _exit(sexp)
    [:int, :_exit]
  end
  def _break(sexp)
    [:jmpr, BreakStop]
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
    result = _to_a(sexp)
    count = result.length
    result = result.reverse.reduce([]) {|i,j|i + [:pushl, j, :swp, :set, :drop] }
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
    fname = car(sexp).to_s.to_sym
    if @named_lambdas[fname]
      lambdacall(sexp)
    else
      _args(sexp) + [:pushl, fname, :icall]
    end
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

  # Main entry: emit(s_expression)
  def emit(sexp)
    result = eval(sexp)
    raise CompileError.new('break statement encountered outside of loop block') if result.any? {|e| e == BreakStop or e.class == BreakStop }
    result
  end
end
