# pry_helper.rb - Invoke with pry -r ./pry_helper.rb

# setup Pry environment
require_relative 'lib/vish'
require_relative 'pry/lib'






def go
  CodeInterpreter.new(*compile(''))
end
def dump_vars ci
  ci.ctx.vars
end


def dump_stack ci
  ci.ctx.stack
end

def one ci
  c = ci.fetch
  i = ci.decode c
  ci.execute i
  puts "code was: #{c}: #{what_is(c)}"
  puts "result stack"
  dump_stack(ci)
end

# Use with go command: for_broke go
def for_broke(ci)
  begin
    ci.run

 rescue HaltState
   # nop
  rescue err
    puts err.message
    puts 'should not have got this'
  end
end


# walker: walks the AST in pre-order, using .each
def walker(ast)
  ast.each {|e| p e.level; p e.content }
  nil
end


  def compile string, &blk
  begin
    parser = (block_given? ? (yield VishParser.new) : VishParser.new)
    compiler = VishCompiler.new string
    compiler.parser = parser
    compiler.run
    compiler
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end
end

  # temp:
  def tmps
  'name=100;vam=25*4;:name != :vam'
  end

  
  def syntax_check string
    begin
      VishParser.new.parse string
    rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
    end
  end



def pa
  return VishParser.new, AstTransform.new
end

# mkast(string) : creates an AST after parsing string.
def mk_ast string
  p, a = pa
  a.apply(p.parse(string))
end

# misty: play misty for me: runs one step
# + ci : The CodeInterpreter
def misty ci, &blk
  print 'stack: '; p ci.ctx.stack
  puts 'vars: '; p ci.ctx.vars
  print 'next instruction: '; p ci.peek
  gets
  ci.step
end

# cifrom - makes a CodeInterpreter from a VishCompiler object
# Parameters:
# compiler : VishCompiler
# Retrurns CodeInterpreter
def cifrom(compiler)
  CodeInterpreter.new(compiler.bc, compiler.ctx)
end

# mkci : Makes a new ci from bc, ctx
# Parameters:
# + bc: ByteCodes
# + ctx : Context
def mkci bc, ctx
  CodeInterpreter.new bc, ctx
end


# bcctx - returns ByteCodes, Context pair
def bcctx
  return ByteCodes.new, Context.new
end

def tree_rdp tokens
  rdp = SimpleRDP.new(array_join(tokens, :+), term_p: ->(v) { StringLiteral.new(v) }, nont_p: ->(o, l, r) { ArithmeticFactory.subtree(o, l, r) })
end
# find_node ast, klass - returns AST node matching klass
def find_node ast, klass
  ast.find {|n| n.content.class == klass }
end
def save_block
  compile 'name={true}; %name'
end


# mkcompiler : returns new VishCompiler
# Parameters : source - source to compile
# returns VishCompiler
def mkcompiler source=''
  VishCompiler.new source
end

def inter source
  c = compile source
  cifrom c
end
def mk_lcall
  [:cls, :pushl, 0, :pushv, :bk, :lcall, :halt]
end

def mk_lambda(ctx, name, target, lname=:Lambda_3)
  ctx.vars[name.to_sym] = lname.to_sym
  ctx.vars[lname.to_sym] = target
end


# gparse - does block within rescue block to capture Parslet errors
def gparse &blk
  begin
    yield
  rescue Parslet::ParseFailed => failure
    puts failure.parse_failure_cause.ascii_tree
  end
end
#  get_statements gets actual statements from AST root. Removes them.
# Parameters
# ast - The AST to work on
# count, the number of statements to extract
def get_statement(ast, count=1)
  result = []
  n = -1
  iters = Array.new(count) {|e| n += 2 }
  iters.each do |i|
    result << ast.children[i]
  end
  result.each {|n| n.remove_from_parent! }
  result
end

def lstr
  "print('b4 lambda assign');m=->() {print('in lambda');1};print('after lambda assign');x=%m();print('at end')"
end
def lstr1
  'm=->() {1};%m()'
end

def lret
  'm=->() { return 2 };%m()'
end

def lbrk
  'defn foo(fn) {%fn()};loop {foo(->() {break}) }'
end