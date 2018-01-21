# builtins.rb - module Builtins - builtin methods


class BreakCalled < RuntimeError; end

module Builtins
  # dup - just dups it input to its output (via the stack)
  def self.dup(arg)
    arg
  end

  # typeof?(obj) - gives the class/??? of the obj
  def self.typeof?(obj)
    if obj.respond_to?(:type)
      obj.send(:type)
    else
    obj.send(:class)
    end
  end

  def self.echo(*args)
    args.map(&:to_s).join(' ') + "\n"
  end

  def self.cat(*args)
    args[0]
  end

  # throw VishRuntimeError with message or default
  def self.throw(*args)
    raise (VishRuntimeError.new(args[0]) || VishRuntimeError.new('Unknown exception'))
  end

  def self.read(*args)
    readline.chomp
  end

  # readi - reads and returns integer
  def self.readi(*args)
    read(*args).to_i
  end

  # Linked list stuff
  def self.list(*args)
    args.flatten
  end
  def self.head(*args)
    args[0][0]
  end

  def self.tail(*args)
    args[0][1..(-1)] || []
  end

  def self.print(*args)
    args.each { |e| $stdout.puts(e.inspect) }
  end

  # dict(:a,1,:b,2,:c,3) => {a: 1, b: 2, c: 3}
  def self.dict(*args)
    evens = array_select(args) {|e,i| i.even? }
    odds = array_select(args) {|e,i| i.odd? }
    evens.zip(odds).to_h
  end

  # ix(arr, index) - should work with lists or dicts (arrays/hashes)
  def self.ix(arr,idx)
    arr[idx]#
  end

  # ax(ar,ix,val) - assigns a value to array or diction
  def self.ax(ar, ix, val)
    ar[ix] = val
  end

  # eval(string) - compiles, interprets string in the current context.
#  def self.eval(string)
#    begin
#      # we need to inject current bc, ctx : How do we get from currently running interpreter?
#      comp = VishCompiler.new(string)
#      comp.run
#      # at this pointwe have new bc: bytecodes and new ctx:context
#      ci = CodeInterpreter.new(comp.bc, comp.ctx)
#      ci.run
#  rescue => err
#    puts err.message
#    end
#  end


  # mkpair(symbol, lambda) - creates PairType
  def self.mkpair(*args)
    PairType.new(args)
  end
  # mklambda - creates LambdaType 
  def self.mklambda(name, arity, target)
    l = LambdaType.new(name, arity)
    l.target = target
    l
  end

  def self.xmit(obj, meth, *args)
    obj.send(meth, *args)
  end
end
