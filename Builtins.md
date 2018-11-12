# builtins.rb - module Builtins - builtin methods


# Vish Language built in functions


  ## The Ruby version as tuple of ints


  ## vish_base(trail) - returns path for base of Vish stuff with optional trailing part


  ## output the version of the runtime


  ## getenv() - returns dictionary object of running environment


  ## getargs() - returns arguments passed to script or program


  ## dup - just dups it input to its output (via the stack)


  ## clone - tries to do a deep clone of argument, else just sends :clone to it


      # Needed before Ruby version 2.4+


  ## typeof(obj) - gives the class/??? of the obj


  ## idof(object) - returns object_id of object


  ## length(object) - if item responds to :length message: returns length as integer, else returns false


  ## reverse vector - reverses a vector : reverse([0,1,2]) # => [2,1,0]


  ## inspect runs inspect on its arguments


  ## echo(args) - concats its string parameters, Lseparated with a single space. ike Bash's echo command.  Outputs a trailing newline.


  ## cat(args) - concats its arguments and returns them


  ## throw VishRuntimeError with message or default


  ## read() - reads from stdin, chomping any trailing newlines.


  ## readi - reads and returns integer


  ## readc - read a single character, do not wait for return


    #consume


  ## File I/O


  ## pwd - the current directory


  ## dir?(path) - true if path is a directory


  ## fexist?(filename) - true if filename exists on disk


  ## freadable?(filename) - true if fname is readable


  ## fwritable?(fname) - true if fname is writable


  ## file?(path) true if path is file and not directory


  ## frm(filename) - removes (unlinks) file if it exists


  ## fread(filename) - reads input file


  ## fwrite('contents, filename) - writes input to filename on disk


  ## Vector stuff


  ##  mkvector(args) - returns vector/array of arguments.


  ## flatten(vector) - flattens nested vector


  ## Linked list stuff


  ## list(args) - returns all args in a Scheme-style list 


  ## headvectorst) - returns the first item on a vector or array.


  ## tail(vector) returns the remaining elements on a vector after the head.


  ## print(args) - outputs all its args to stdout.


  ## prints string - prints string w/o newlines


  ## chars(string) - string.chars


  ## gensym() - creates unique id


  ## range(start, end) - Creates new range type


  ## dict - returns object hash with every 2 items as key/value pairs.


  ## mksym(string_or_sym) - returns Symbol


  ## mkpair(k, v) - given two values returns PairType


  ## cons(object, object) - returns new PairType


  ## pair?(object) - true if object is PairType


  ## empty?(object) - true if object is an empty collection


  ## zero? object - true if object is zero


  ## list?(possible_list) - true if really a list


  ## binding?(object) - true if object is some binding


  ## object?(object) - true if object is ObjectType : Dictionary/Hash


  ## vector?(object) - true if object is VectorType


  ## eq?(obj1, obj2) - true if obj1 is the same object as obj2


  ## atom?(object) - true if not a list


  ## key(pair) - returns .key member from PairType


  ## value(pair) - returns the value member from PairType


  ## mkobject(pairs=[]) - create instance of type ObjectType


    ## mknull() - returns Null instance


  ## nul?(list) - true if list is the Null list : ()


  ## undefined? object - true if object is an undefined


  ## ix(arr, index) - should work with lists or dicts (arrays/hashes)


    arr[idx]#


  ## ax(ar,ix,val) - assigns a value to array or diction


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


  ## lambda?(object)


  # xmit(object, message) - sends Ruby message to object and returns its result.


  ## string?(object) - true if object is a string


  ## boolean? object - true if object is a true or false expression


  ## number?(object) - true if object an integer


  ## symbol?(object) - true if object is a Symbol


  ## max args - returns maximum of args


  ## min args - returns minimum of args


  # string/array methods: chomp, split and join


    ## chompstring - chomps a string


  ## join array, sep - joins array with sep or empty string


    arr.join(sep)#


  ## split string, sep - array  


  ## shx input, command - Run the command through the shell and gather stdout


  ## and return it  along with stderr and status code


