# ast_transform.rb - class AstTransform <  Parslet::Transform
Dummy='dummy'

#require_relative 'vish'

class AstTransform < Parslet::Transform
  # debugging

  # handle the empty input case
  rule(empty: simple(:empty)) { Ignore.new }

  rule(int: simple(:int)) { Numeral.new(int) }
  # single quoted strings
  rule(sq_string: simple(:sq_string)) { StringLiteral.new(sq_string) }
  rule(sq_string: sequence(:sq_string)) { StringLiteral.new('') }

  # double quoted strings: string interpolations
  rule(strtok: simple(:strtok)) { StringLiteral.new(strtok) }
  rule(escape_seq: simple(:escape_seq)) { EscapeSequence.new(escape_seq) }
  rule(string_expr: simple(:string_expr)) { SubtreeFactory.subtree(StringExpression, string_expr) }

  rule(string_interpolation: sequence(:string_interpolation)) { StringInterpolation.subtree(string_interpolation) }
  rule(boolean: simple(:boolean)) { Boolean.new(boolean) }
  rule(symbol: simple(:symbol)) { SymbolType.new(symbol) }
  rule(list: simple(:list), arglist: simple(:arg)) { FunctorNode.subtree(ListType.new, [arg]) }
  rule(list: simple(:list), arglist: sequence(:arg)) { FunctorNode.subtree(ListType.new, arg) }
  rule(object: simple(:object), arglist: simple(:arglist)) { ObjectNode.subtree([arglist]) }
  rule(object: simple(:object), arglist: sequence(:arglist)) { ObjectNode.subtree(arglist) }
  rule(symbol: simple(:symbol), expr: subtree(:expr)) { PairNode.subtree(SymbolType.new(symbol),expr) }

  # deref an object with dotted method
  rule(deref: simple(:deref), list: simple(:list), symbol: simple(:symbol)) { DerefList.subtree(Deref.new(deref), SymbolType.new(symbol)) }

  # deref a list w/index
  rule(deref: simple(:deref), list: simple(:list), arglist: simple(:arglist)) { DerefList.subtree(Deref.new(deref), arglist) }
  rule(vector_id: simple(:id), list: simple(:list), index: simple(:index))  { VectorId.subtree(Deref.new(id), index) }

  # IList indexed lambda call: %a[0] TODO: Add backin parens and args
  rule(lambda_call: simple(:deref),list: simple(:list), arglist: simple(:arglist), lambda_args: simple(:lambda_args)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(deref), arglist), [lambda_args]) }
  rule(lambda_call: simple(:deref),list: simple(:list), arglist: simple(:arglist), lambda_args: sequence(:lambda_args)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(deref), arglist), lambda_args) }

  rule(lambda_call: simple(:deref),list: simple(:list), arglist: simple(:arglist)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(deref), arglist)) }

  # method call %p.foo; %p.foo(0); %p.foo(1,2,3)
  rule(lambda_call: simple(:lambda_call), execute_index: simple(:execute_index), index: simple(:index)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(lambda_call), SymbolType.new(index)), []) } 
  rule(lambda_call: simple(:lambda_call), execute_index: simple(:execute_index), index: simple(:index), arglist: simple(:arglist)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(lambda_call), SymbolType.new(index)), [arglist]) } 
  rule(lambda_call: simple(:lambda_call), execute_index: simple(:execute_index), index: simple(:index), arglist: sequence(:arglist)) { LambdaCallList.subtree(DerefList.subtree(Deref.new(lambda_call), SymbolType.new(index)), arglist) }


  # logical operations

  # arithmetic expressions
  rule(l: simple(:lvalue), o: simple(:op), r: simple(:rvalue)) { ArithmeticFactory.subtree(op, lvalue, rvalue) }
  # Assignment
  rule(vector: subtree(:lvalue), eq: simple(:eq), rvalue: simple(:rvalue)) { BinaryTreeFactory.subtree(VectorAssign, lvalue, rvalue) }
  rule(lvalue: simple(:lvalue), eq: simple(:eq), rvalue: simple(:rvalue)) { BinaryTreeFactory.subtree(Assign, LValue.new(lvalue), rvalue) }
  rule(lvalue: simple(:lvalue), eq: simple(:eq), rvalue: subtree(:_lambda)) { BinaryTreeFactory.subtree(Assign, LValue.new(lvalue), _lambda)  }

  rule(op: simple(:op), negation: simple(:negation)) { UnaryTreeFactory.subtree(UnaryNegation, negation) }

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

  # The root of the IR
  rule(program: simple(:program)) { ProgramFactory.tree(program) }
  rule(program: sequence(:program)) { ProgramFactory.tree(*program) }
end

