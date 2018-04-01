# Vish Language built in functions

## output the version of the runtime

## getenv() - returns dictionary object of running environment

## getargs() - returns arguments passed to script or program, including name of

## script or ivs

## dup - just dups it input to its output (via the stack)

## typeof(obj) - gives the class/??? of the obj

## inspect runs inspect on its arguments

## echo(args) - concats its string parameters, Lseparated with a single space. ike Bash's echo command.

## Outputs a trailing newline.

## cat(args) - concats its arguments and returns them

## throw VishRuntimeError with message or default

## read() - reads from stdin, chomping any trailing newlines.

## readi - reads and returns integer

## readc - read a single character, do not wait for return

## File I/O

## pwd - the current directory

## dir?(path) - true if path is a directory

## file?(path) -true if file exists and is not a directory

## fexist?(filename) - true if filename exists on disk

## frm(filename) - removes (unlinks) file if it exists

## fread(filename) - reads input file

## fwrite('contents, filename) - writes input to filename on disk


##  mkvector(args) - returns vector/array of arguments.

## flatten(vector) - flattens nested vector

## list(args) - returns all args in a Scheme-style list 

## headvectorst) - returns the first item on a vector or array.

## tail(vector) returns the remaining elements on a vector after the head.

## print(args) - outputs all its args to stdout.

## dict(:a,1,:b,2,:c,3) => {a: 1, b: 2, c: 3}

## mksym(string_or_sym) - returns Symbol

## mkpair(k, v) - given two values returns PairType

## cons(object, object) - returns new PairType

## pair?(object) - true if object is PairType

## list?(possible_list) - true if really a list

## atom?(object) - true if not a list

## key(pair) - returns .key member from PairType

## value(pair) - returns the value member from PairType

## mkobject(pairs=[]) - create instance of type ObjectType

  ## mknull() - returns Null instance

## nul?(list) - true if list is the Null list : ()

## ix(arr, index) - should work with lists or dicts (arrays/hashes)


## ax(ar,ix,val) - assigns a value to array or diction

  ## mklambda - creates LambdaType 

  # xmit(object, message) - sends Ruby message to object and returns its result.

