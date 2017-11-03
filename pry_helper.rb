# pry_helper.rb - Invoke with pry -r ./pry_helper.rb

# setup Pry environment
require_relative 'lib/vish'





def what_is code
  result = 'undefined'
  {
    # 
    pushc:  'pushes value of indexed constant',

    # :pushv : 
    pushv: 'Pushes value of named variable',
    
    # :pushl - 
    pushl: 'Pushes name of LValue on stack',

    # Arithmetic instructions. TODO:  add these: sub: mult: and div:
    # TODO: Should we add Logical ops like :and and :or ?
    # :add - 
    add: 'BinararyAdd - Pops 2 operands and pushes the result of adding them',

    # assignments and dereferences
    # :assign - 
    assign: 'Pop the name of the var, pop the value, store in ctx.vars',

    # environment instructions : print, . .etc
    print: 'Pops top value of stack and prints it to standard out',

    # machine low-level instructions: nop, halt, jmp, error, etc.
    # :cjmp - jump if top of stack is true. Do we need the opposite?
    nop: ->(bc, ctx) { },
    halt: ->(bc, ctx) { raise HaltState.new },
    error: ->(bc, ctx) { raise ErrorState.new }
  }[code] || result
end

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


  def compile string
    ir = VishParser.new.parse string
    ast = AstTransform.new.apply ir
    emit_walker ast
  end
  