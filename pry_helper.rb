# pry_helper.rb - Invoke with pry -r ./pry_helper.rb

# setup Pry environment
require_relative 'lib/vish'
require_relative 'pry/lib'






def go
  CodeInterperter.new(*compile(''))
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
  ast.each {|e| p e.content }
  nil
end


  def compile string, &blk
  begin
  parser = (block_given? ? (yield VishParser.new) : VishParser.new)
    ir = parser.parse string
    ast = AstTransform.new.apply ir
    emit_walker ast  
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

# misty: play misty for me: runs one step
# + ci : The CodeInterperter
def misty ci, &blk
  print 'stack: '; p ci.ctx.stack
  puts 'vars: '; p ci.ctx.vars
  print 'next instruction: '; p ci.peek
  gets
  ci.step
end


# mkci : Makes a new ci from bc, ctx
# Parameters:
# + bc: ByteCodes
# + ctx : Context
def mkci bc, ctx
  CodeInterperter.new bc, ctx
end


def tree_rdp tokens
  rdp = SimpleRDP.new(array_join(tokens, :+), term_p: ->(v) { StringLiteral.new(v) }, nont_p: ->(o, l, r) { ArithmeticFactory.subtree(o, l, r) })
end