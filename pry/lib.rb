# lib.rb - Shared helper functions for pry_helper.rb wherever they may be found

require_relative 'debug'



class MockArray
  def [] index
    puts "[#{index}]"
  end
  def []= index, value
    puts "[#{index}]=#{value}"
    value
  end
end
class MockBc
  def pc
    0
  end
  def codes
    MockArray.new
  end
  def next
  puts 'bc.next'
    :nop
  end
end

class MockStack
  def pop
    puts 'stack.pop'
    StalkingHorse.new
  end

  def push item
    puts "stack.push(#{item.inspect})"
    item
  end
  def clear
    puts 'stack.clear'
  end
end

class MockVars
  def [] key
    puts "vars[#{key}]"
  end
  def []= key, value
    puts "vars[#{key}] = #{value.inspect}"
    value
  end
end


class StalkingHorse
  def method_missing name, *args, **keys
    puts name.to_s + '('
      args.each {|a| p a }
  end
end

class MockCtx
  def initialize
    @constants = MockArray.new
    @stack = MockStack.new
    @vars = MockVars.new
  end
  attr_accessor :constants, :stack, :vars
end

def what_will_happen code
  bc  = MockBc.new
  ctx = MockCtx.new
  l = opcodes[code] || ->(_bc, _,ctx) { 'undefined' }
  l.call(bc, ctx)
end





# add_underline symbol
# Adds a underline to tpassed symbol, returns the new symbol.
# Parameters:
# + symbol - the symbol to enhance
def add_underline symbol
  ('_' + symbol.to_s).to_sym
end
# what_is: bytecode - help text forvarious opcodes
# + code : The byte code to inspect
def what_is code
  print "#{code}: "
   puts(opcodes[add_underline(code)] || 'undefined')
end

# array_walker, hash_walker - used to traverse output of Parslet::Parser first stage. IR
def array_walker arr
  puts '['
  arr.each do |n|
    case n
    when Array
      array_walker n
    when Hash
      hash_walker n
    else
      p n
    end
  end
  puts ']'
end





def hash_walker h
  puts '{'
  h.each do |k, v|
    print "\n#{k} => "
    case v
    when Hash
      hash_walker v
    when Array
      array_walker v
    else
      print v.inspect
    end
  end
  puts '}'
end
