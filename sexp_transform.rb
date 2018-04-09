# sexp_transform.rb - Parse transform that returns S-expressions as PairType

def mksexp(k, v)
  PairType.new(key: k, value: v)
end

def sbool(bool)
  mksexp(:bool, bool)
end
# identifier
def sident(x)
  mksexp(:ident, x)
end

# integer
def sint(number)
  mksexp(:integer, number)
end
# sstrlit - StringLiteral
def sstrlit(x)
  mksexp(:string, x)
end
# symb ol
def ssymbol(x)
  mksexp(:symbol, x)
end
# make a pair: of s:symbol, e:expression
def spair(s, e)
  mklist(:pair, s, e)
end
# Vector
def svector(args)
  mklist(:vector, mklist(*args))
end
# objects: dics or Ruby hash
def sobject(arglist)
  mklist(:object, mklist(*arglist))
end

def signore()
  PairType.new(key: :ignore, value: NullType.new)
end

def shalt()
  mksexp(:halt, :_)
end

# utility
def mklist(*args)
  Builtins.list(*args)
end

def add(l, r)
  Builtins.list(:add, l, r)
end
def sub(l, r)
  Builtins.list(:sub, l, r)
end
def mult(l, r)
  Builtins.list(:mult, l, r)
end
def div(l, r)
  Builtins.list(:div, l, r)
end
def modulo(l, r)
  mklist(:modulo, l, r)
end
def exponent(l, r)
  mklist(:exp, l, r)
end
# logical
def bool_and(l, r)
  mklist(:and, l, r)
end
def bool_or(l, r)
  mklist(:or, l, r)
end
# assignment
def assign(l, r)
  mklist(:assign, l, r)
end

# mkarith - Make arithmetic subexpression
def mkarith(o, l, r)
  msgs = {
    '=' => :assign, 
    'and' => :bool_and,
    'or' => :bol_or,
    "**" => :exponent,
    "%" => :modulo,
    "+" => :add,
    "-" => :sub,
    "*" => :mult,
    "/" => :div
  }
  m = msgs[o.to_s.strip]
  if m.nil?
    binding.pry
    raise CompileError.new 'Unknown arithmetic expression type'
  else
    self.send m, l, r
  end
end

def sroot tree
  Builtins.list(:program, tree)
end
class SexpTransform < Parslet::Transform
  # single quoted strings
#  rule(sq_string: simple(:sq_string)) { StringLiteral.new(sq_string) }
#  rule(sq_string: sequence(:sq_string)) { StringLiteral.new('') }

  # double quoted strings: string interpolations
  rule(strtok: simple(:strtok)) { StringLiteral.new(strtok) }
  rule(escape_seq: simple(:escape_seq)) { EscapeSequence.new(escape_seq) }
  rule(string_expr: simple(:string_expr)) { SubtreeFactory.subtree(StringExpression, string_expr) }

  rule(string_interpolation: sequence(:string_interpolation)) { StringInterpolation.subtree(string_interpolation) }
#  rule(boolean: simple(:boolean)) { Boolean.new(boolean) }
#  rule(symbol: simple(:symbol)) { SymbolNode.new(symbol) }
#  rule(list: simple(:list), arglist: simple(:arg)) { FunctorNode.subtree(VectorNode.new, [arg]) }
#  rule(list: simple(:list), arglist: sequence(:arg)) { FunctorNode.subtree(VectorNode.new, arg) }
#  rule(object: simple(:object), arglist: simple(:arglist)) { ObjectNode.subtree([arglist]) }
#  rule(object: simple(:object), arglist: sequence(:arglist)) { ObjectNode.subtree(arglist) }
#  rule(symbol: simple(:symbol), expr: subtree(:expr)) { PairNode.subtree(SymbolNode.new(symbol),expr) }

  # deref an object with dotted method
  rule(deref: simple(:deref), list: simple(:list), symbol: simple(:symbol)) { DerefList.subtree(Deref.new(deref), SymbolNode.new(symbol)) }

  # deref a list w/index
  rule(deref: simple(:deref), list: simple(:list), arglist: simple(:arglist)) { DerefList.subtree(Deref.new(deref), arglist) }
  rule(vector_id: simple(:id), list: simple(:list), index: simple(:index))  { VectorId.subtree(Deref.new(id), index) }

  # IList indexed lambda call: %a[0] TODO: Add backin parens and args
  rule(lambda_call: simple(:deref),list: simple(:list), arglist: simple(:arglist), lambda_args: simple(:lambda_args)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(deref), arglist), [lambda_args]) }
  rule(lambda_call: simple(:deref),list: simple(:list), arglist: simple(:arglist), lambda_args: sequence(:lambda_args)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(deref), arglist), lambda_args) }

  rule(lambda_call: simple(:deref),list: simple(:list), arglist: simple(:arglist)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(deref), arglist)) }

  # method call %p.foo; %p.foo(0); %p.foo(1,2,3)
  rule(lambda_call: simple(:lambda_call), execute_index: simple(:execute_index), index: simple(:index)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(lambda_call), SymbolNode.new(index)), []) } 
  rule(lambda_call: simple(:lambda_call), execute_index: simple(:execute_index), index: simple(:index), arglist: simple(:arglist)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(lambda_call), SymbolNode.new(index)), [arglist]) } 
  rule(lambda_call: simple(:lambda_call), execute_index: simple(:execute_index), index: simple(:index), arglist: sequence(:arglist)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(lambda_call), SymbolNode.new(index)), arglist) }


  # logical operations

  # arithmetic expressions
#  rule(l: simple(:lvalue), o: simple(:op), r: simple(:rvalue)) { ArithmeticFactory.subtree(op, lvalue, rvalue) }
  # Assignment
  rule(vector: subtree(:lvalue), eq: simple(:eq), rvalue: simple(:rvalue)) { BinaryTreeFactory.subtree(VectorAssign, lvalue, rvalue) }
  rule(lvalue: simple(:lvalue), eq: simple(:eq), rvalue: simple(:rvalue)) { BinaryTreeFactory.subtree(Assign, LValue.new(lvalue), rvalue) }
#  rule(lvalue: simple(:lvalue), eq: simple(:eq), rvalue: subtree(:_lambda)) { BinaryTreeFactory.subtree(Assign, LValue.new(lvalue), _lambda)  }

  rule(op: simple(:op), negation: simple(:negation)) { UnaryTreeFactory.subtree(UnaryNegation, negation) }
  rule(op: simple(:op), negative: simple(:negative)) { UnaryTreeFactory.subtree(UnaryNegative, negative) }

  # dereference a variable
  rule(deref: simple(:deref)) { mknode(Deref.new(deref)) }
  # deref a variable (or function arg) and execute it immediately
  rule(deref_block: simple(:deref_block)) {  mknode(DerefBlock.new(deref_block)) }

  # keyword stuff
  rule(null: simple(:keyword)) { Keyword.subtree(keyword) }
  rule(return: simple(:return_expr)) { LambdaReturn.subtree(return_expr) }
  rule(keyword: simple(:keyword)) { Keyword.subtree(keyword) }
  rule(keyword: subtree(:keyword)) { Keyword.subtree(keyword) }

  # loop stuff
  rule(loop: simple(:loop)) { Loop.subtree(loop) }

  # block stuff
  rule(block: simple(:block)) { Block.subtree([block]) }
  rule(block: sequence(:block)) { Block.subtree(block) }

  rule(block_exec: simple(:block)) { BlockExec.subtree([block]) }
  rule(block_exec: sequence(:block)) { BlockExec.subtree(block) }

  # lambdas
  rule(parm: simple(:parm)) { StringLiteral.new(parm) }
  rule(parmlist: simple(:parmlist), _lambda: simple(:_lambda)) { Lambda.subtree([parmlist], _lambda) }
  rule(parmlist: sequence(:parmlist), _lambda: simple(:_lambda)) { Lambda.subtree(parmlist, _lambda) }

  # Functions
  # Change here
  rule(fname: simple(:fname), block: simple(:fbody), parmlist: simple(:parmlist)) { BinaryTreeFactory.subtree(Assign, LValue.new(fname), NamedLambda.subtree([parmlist], fbody, fname)) }
  rule(fname: simple(:fname), block: simple(:fbody), parmlist: sequence(:parmlist)) { BinaryTreeFactory.subtree(Assign, LValue.new(fname), NamedLambda.subtree(parmlist, fbody, fname)) }


#  rule(fname: simple(:fname), parmlist: simple(:parmlist), block: simple(:fbody)) { Function.subtree(fname, fbody, [parmlist]) } 
#  rule(fname: simple(:fname), parmlist: sequence(:parmlist), block: simple(:fbody)) { Function.subtree(fname, fbody, parmlist) } 


  # Function calls, Lambda calls, etc.
  rule(funcall: simple(:funcall), arglist: simple(:arg)) { FunctorNode.subtree(Funcall.new(funcall), [arg]) }
  rule(funcall: simple(:funcall), arglist: sequence(:arglist)) { FunctorNode.subtree(Funcall.new(funcall), arglist) }

  # Lambda call - %l;%l();%l(1,2,3)
  rule(lambda_call: simple(:lambda_call)) { FunctorNode.subtree(LambdaCall.new(lambda_call), []) }
  rule(lambda_call: simple(:lambda_call), arglist: simple(:arglist)) { FunctorNode.subtree(LambdaCall.new(lambda_call), [arglist]) }
  rule(lambda_call: simple(:lambda_call), arglist: sequence(:arglist)) { FunctorNode.subtree(LambdaCall.new(lambda_call), arglist) }

  #####
  rule(lvalue: simple(:lvalue), eq: simple(:eq), rvalue: simple(:rvalue)) { mkarith(eq, sident(lvalue), rvalue) }  #BinaryTreeFactory.subtree(Assign, LValue.new(lvalue), rvalue) }

  # Objects
  rule(object: simple(:object), arglist: simple(:arglist)) { sobject(arglist) }   #ObjectNode.subtree([arglist]) }
  rule(object: simple(:object), arglist: sequence(:arglist)) {sobject(arglist) }   #ObjectNode.subtree(arglist) }
  # vectors
  rule(list: simple(:list), arglist: simple(:arg)) { svector(arg) }   #FunctorNode.subtree(VectorNode.new, [arg]) }
  rule(list: simple(:list), arglist: sequence(:args)) { svector(args) }  #FunctorNode.subtree(VectorNode.new, arg) }
  rule(symbol: simple(:symbol), expr: subtree(:expr)) { spair(ssymbol(symbol),expr) }     # PairNode.subtree(SymbolNode.new(symbol),expr) }

  rule(symbol: simple(:symbol)) {ssymbol(symbol) }   #SymbolNode.new(symbol) }

  rule(sq_string: simple(:sq_string)) { sstrlit(sq_string) }  # StringLiteral.new() }
  rule(sq_string: sequence(:sq_string)) { sstrlit('') }   #StringLiteral.new('') }
  rule(boolean: simple(:boolean)) { sbool(boolean) }
  # Boolean.new() }

  rule(int: simple(:int)) { sint(int) }
  rule(l: simple(:lvalue), o: simple(:op), r: simple(:rvalue)) { mkarith(op, lvalue, rvalue) }


  rule(empty: simple(:empty)) { signore }

  # The root of the IR
  rule(program: simple(:program)) { sroot(program) }
  rule(program: sequence(:program)) { sroot(program) }
end
