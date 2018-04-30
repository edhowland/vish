# builtins.rb - module Builtins - builtin methods
require 'fileutils'
require 'readline'




class BreakCalled < RuntimeError; end


# Vish Language built in functions
module Builtins
  ## output the version of the runtime
  def self.version()
    Vish::VERSION
  end
  ## getenv() - returns dictionary object of running environment
  def self.getenv()
    ENV
  end
  ## getargs() - returns arguments passed to script or program, including name of
  ## script or ivs
  def self.getargs()
    ARGV
  end

  ## dup - just dups it input to its output (via the stack)
  def self.dup(arg)
    arg
  end

  ## typeof(obj) - gives the class/??? of the obj
  def self.typeof(obj)
    if obj.respond_to?(:type)
      obj.send(:type)
    else
    obj.send(:class)
    end
  end

  ## length(object) - if item responds to :length message: returns length as integer
  ### else returns false
  def self.length(object)
    if object.respond_to?(:length)
      object.length
    else
      false
    end
  end

  ## inspect runs inspect on its arguments
  def self.inspect(*args)
    args.inspect
  end

  ## echo(args) - concats its string parameters, Lseparated with a single space. ike Bash's echo command.
  ## Outputs a trailing newline.
  def self.echo(*args)
    args.map(&:to_s).join(' ') + "\n"
  end

  ## cat(args) - concats its arguments and returns them
  def self.cat(*args)
    args.join
  end

  ## throw VishRuntimeError with message or default
  def self.throw(*args)
    raise (VishRuntimeError.new(args[0]) || VishRuntimeError.new('Unknown exception'))
  end

  ## read() - reads from stdin, chomping any trailing newlines.
  def self.read()
    result = Readline.readline
    result = result.chomp unless result.nil?
    result
  end

  ## readi - reads and returns integer
  def self.readi(*args)
    read(*args).to_i
  end
  ## readc - read a single character, do not wait for return
  def self.readc()
    $stdin.getch
    #consume
  end

  ## File I/O

  ## pwd - the current directory
  def self.pwd()
    FileUtils.pwd
  end

  ## dir?(path) - true if path is a directory
  def self.dir?(path)
    File.directory?(path)
  end
  ## fexist?(filename) - true if filename exists on disk
  def self.fexist?(name)
    File.exist?(name)
  end
  ## file?(path) true if path is file and not directory
  def self.file?(path)
    fexist?(path) && !dir?(path)
  end
  ## frm(filename) - removes (unlinks) file if it exists
  def self.frm(name)
    fexist?(name) && File.unlink(name)
  end

  ## fread(filename) - reads input file
  def self.fread(name)
    File.read(name)
  end

  ## fwrite('contents, filename) - writes input to filename on disk
  def self.fwrite(contents, name)
    File.write(name, contents)
  end
  ## Vector stuff
  ##  mkvector(args) - returns vector/array of arguments.
  def self.mkvector(*args)
    VectorFactory.build(args)
  end
  ## flatten(vector) - flattens nested vector
  def self.flatten(vector)
    vector.flatten
  end

  ## Linked list stuff
  ## list(args) - returns all args in a Scheme-style list 
  def self.list(*args)
    args.reverse.reduce(mknull()) {|i, j| cons(j, i) }
  end

  ## headvectorst) - returns the first item on a vector or array.
  def self.head(*args)
    args[0][0]
  end
  ## tail(vector) returns the remaining elements on a vector after the head.
  def self.tail(*args)
    args[0][1..(-1)] || []
  end

  ## print(args) - outputs all its args to stdout.
  def self.print(*args)
    args.each { |e| $stdout.puts(e.inspect) }
  end
  ## prints string - prints string w/o newlines
  def self.prints(string)
    $stdout.print string
  end

  ## dict(:a,1,:b,2,:c,3) => {a: 1, b: 2, c: 3}
  def self.dict(*args)
    evens = array_select(args) {|e,i| i.even? }
    odds = array_select(args) {|e,i| i.odd? }
    evens.zip(odds).to_h
  end

  ## mksym(string_or_sym) - returns Symbol
  def self.mksym(v)
    v.to_sym
  end

  ## mkpair(k, v) - given two values returns PairType
  def self.mkpair(key, value)
    PairType.new(key:key, value:value)
  end
  ## cons(object, object) - returns new PairType
  def self.cons(ar, dr)
    mkpair(ar, dr)
  end
  ## pair?(object) - true if object is PairType
  def self.pair?(object)
    object.kind_of?(PairType)
  end
  ## empty?(object) - true if object is an empty collection
  def self.empty?(collection)
    if list?(collection)
      null?(collection)
    elsif collection.respond_to?(:empty?)
      collection.empty?
    else
      false
    end
  end
  ## zero? object - true if object is zero
  def self.zero?(object)
    if object.respond_to?(:zero?)
      object.zero?
    else
      false
    end
  end
  ## list?(possible_list) - true if really a list
  def self.list?(object)
    return false unless pair?(object)
    o = object
    while (pair?(o) && !null?(o))
      o = o.value
    end
    null?(o)
  end
  ## object?(object) - true if object is ObjectType : Dictionary/Hash
  def self.object?(object)
    object.kind_of?(ObjectType)
  end
  ## vector?(object) - true if object is VectorType
  def self.vector?(object)
    object.kind_of?(VectorType)
  end
  ## eq?(obj1, obj2) - true if obj1 is the same object as obj2
  def self.eq?(o1, o2)
    o1.equal?(o2)
  end
  ## atom?(object) - true if not a list
  def self.atom?(object)
    not(pair?(object)) && not(list?(object)) && not(string?(object)) && not(vector?(object)) && not(object?(object))
  end

  ## key(pair) - returns .key member from PairType
  def self.key(pair)
    pair.key
  end

  ## value(pair) - returns the value member from PairType
  def self.value(pair)
    pair.value
  end

  ## mkobject(pairs=[]) - create instance of type ObjectType
  def self.mkobject(*args)
    ObjectFactory.build(args)
  end
    ## mknull() - returns Null instance
  def self.mknull()
    NullType.new
  end
  ## nul?(list) - true if list is the Null list : ()
  def self.null?(object)
    object.instance_of?(NullType)
#    pair?(object) && NullType.instance_of?(object)  #PairType.null?(object)
  end

  ## ix(arr, index) - should work with lists or dicts (arrays/hashes)
  def self.ix(arr,idx)
    arr[idx]#
  end

  ## ax(ar,ix,val) - assigns a value to array or diction
  def self.ax(ar, ix, val)
    ar[ix] = val
  end

  ## eval(string) - compiles, interprets string in the current context.
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



  ## mklambda - creates LambdaType 
  def self.mklambda(name, arity, target)
    l = LambdaType.new(name, arity)
    l.target = target
    l
  end
  ## lambda?(object)
  def self.lambda?(object)
    object.class == NambdaType # LambdaType # TODO replace this back
  end

  # xmit(object, message) - sends Ruby message to object and returns its result.
  def self.xmit(obj, meth, *args)
    obj.send(meth, *args)
  end
  ## string?(object) - true if object is a string
  def self.string?(object)
    object.instance_of?(String)
  end
  ## boolean? object - true if object is a true or false expression
  def self.boolean?(object)
    [TrueClass, FalseClass].member?(object.class)
  end
  ## number?(object) - true if object an integer
  def self.number?(object)
    object.kind_of?(Integer)
  end
  ## symbol?(object) - true if object is a Symbol
  def self.symbol?(object)
    object.instance_of?(Symbol)
  end
end
