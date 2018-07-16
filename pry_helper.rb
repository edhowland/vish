# pry_helper.rb - Invoke with pry -r ./pry_helper.rb

# setup Pry environment
require_relative 'lib/vish'
require_relative 'pry/lib'
#require_relative 'sexp_transform'
#require_relative 'list_proc'
#require_relative 'semit'








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

  
  def syntax_check string, &blk
  if block_given?
    parser = yield
  else
    parser = VishParser.new
  end
    begin
      parser.parse string
    rescue Parslet::ParseFailed => failure
  puts failure.parse_failure_cause.ascii_tree
    end
  end



# ps - return VisParser, SexpTransform
def ps
  [VishParser.new, SexpTransform.new]
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

## interpret source runs full compiler stack
def interpret(source)
  c = compile(source)
  ci = cifrom(c)
  ci.run
end

## _inter source get the CodeInterpreter from compiling some source
def _inter source
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

# pr string - return result and parse errors
def pr str='', &blk
  err=nil
  begin
    if block_given?
      result = yield
    else
      result = interpret str
    end
  rescue Parslet::ParseFailed => err
  end
  [result, err]
end
# extract the Ascii art tree of the parse error
def art obj
  case obj
  when Array
    puts obj.last.parse_failure_cause.ascii_tree
  else
  puts obj.message
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

def vc source=''
  VishCompiler.new source
end

def block_another
        'bk1={1+3};bk2={5*%bk1};%bk2' # , 20
end


def exl(lambdas)
  lambdas.keys.each do |k|
    puts "For #{k}"
    t1, t2 = lambdas[k]
    puts "  #{t1.content.inspect}"
    puts "  #{t2.content.inspect}"
    puts "    Value is #{t2.content.value.class.name}."
    puts "    contents: #{t2.content.value.inspect}"
  end
end

def bcdiff(l1, l2)
  l1.each_with_index do |e, i|
#puts "checking index #{i} at l1: #{l1[i]} against l2 #{l2[i]}"
    if e != l2[i]
              puts "differenced detected @#{i} l1[#{i}] is #{l1[i]} l2[#{i}] is #{l2[i]}"
      break
    end
  end
end


def fun_lamb
  ['defn foo() {->() {9}};x=%foo;%x','foo=->() {->() {9}};x=%foo;%x']
end
def cons(k, v)
  Builtins.mkpair(k, v)
end

def car(x)
  x.key
end
def cdr(x)
  x.value
end
def cadr(x)
  car(cdr(x))
end
def caadr(x)
  car(cadr(x))
end
def cddr(x)
  cdr(cdr(x))
end
def caddr(x)
  car(cddr(x))
end

# utility fns from Builtins



# walk the S-expression tree
def swalk(t)

  return nil if null?(t)
  if atom?(t)
#    puts "atom: #{t.inspect}"
    return nil
  end
  x = car(t)
  if null?(x)
    puts 'ascending at end of list'
    return nil
  elsif atom?(x)
    puts x.inspect
  elsif list?(x)
    puts 'descending'
    swalk(x)
  elsif pair?(x)
    puts "pair: #{x.key}: #{x.value}"
  else
    puts 'error'
  end
  swalk(cdr(t))
end


def walks(t)
  begin
    swalk(t)
  rescue => err
puts "swalk: error: #{err.message}"
  end
end

def ex str, p=VishParser.new, s=SexpTransform.new
  s.apply(p.parse(str))
end


def pse
  ps + [Semit.new]
end

def gsexp str
  p,s=ps
  s.apply(p.parse(str))
end

def compute str
  p,s,e = pse
  codes = e.emit(s.apply(p.parse(str)))
  ctx = Context.new
  bc = ByteCodes.new
  bc.codes = codes
  ci = CodeInterpreter.new bc, ctx
  ci.run
end
def cx codes
    ctx = Context.new
  bc = ByteCodes.new
  bc.codes = codes
  ci = CodeInterpreter.new bc, ctx
end

def ml str
  "a=:<#{str}>:;body=_emit(:a);foo=_mklambda(:body, binding())"
end
# libvs - read in std/lib.vs
def libvs
  File.read('std/lib.vs')
end
def mkhook
  ->(i) {
    return unless i.bc.peek == :fret
    puts "\n------\n"
    i.frames.each {|f| puts "#{f.class.name}: ret: #{f.return_to}\n" }
    puts "-----"
  }
end

def fg()
  'defn f() {g()};defn g() {99};f()'
end
def fact(n)
  "defn fact(n) {:n == 0 && return 1; :n * fact(:n - 1)};fact(#{n})"
end

def mkh
  n=0
  [->() {n}, ->(i) { return unless i.bc.peek == :fret; n = [n,i.frames.length].max }]
end
def afact(n)
  <<-EOD
  defn fact(n) {
      defn aux(n, acc) {
        :n == 0 && return :acc
        aux(:n - 1, :n * :acc)
      }
      aux(:n, 1)
    }
    fact(#{n})
  EOD
end

def li(n)
  "list(" + (1..n).to_a.inspect[1..-2] + ")"
end

# ll - create lambda :ll to calculate length of list
# Use with above li(n) method: interpret ll(li(9)) # => 9
def ll(list)
  <<-EOD
      defn cdr(l) { value(:l) }
    defn ll(l) {
      {null?(:l) && 0} || 1 + ll(cdr(:l))
    }
    l=#{list}
    ll(:l)
EOD
end