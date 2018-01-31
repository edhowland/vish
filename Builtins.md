# Builtin functions

- output the version of the runtime
- dup - just dups it input to its output (via the stack)
- typeof(obj) - gives the class/??? of the obj
- inspect runs inspect on its arguments
- echo(args) - concats its string parameters, Lseparated with a single space. ike Bash's echo command.
- cat(args) - concats its arguments and returns them
- throw VishRuntimeError with message or default
- read() - reads from stdin, chomping any trailing newlines.
- readi - reads and returns integer

## File I/O

- pwd - the current directory
- dir?(path) - true if path is a directory
- fexist?(filename) - true if filename exists on disk
- frm(filename) - removes (unlinks) file if it exists
- fread(filename) - reads input file
- fwrite('contents, filename) - writes input to filename on disk

## Linked list stuff

- list(args) - returns all args in a list
- head(list) - returns the first item on a list.
- tail(list) returns the remaining elements on a list after the head.

## Misc.

- print(args) - outputs all its args to stdout.
- mksym(string_or_sym) - returns Symbol
- mkpair(k, v) - given two values returns PairType
- key(pair) - returns .key member from PairType
- value(pair) - returns the value member from PairType
- mkobject(pairs=[]) - create instance of type ObjectType
- ix(arr, index) - should work with lists or dicts (arrays/hashes)
- ax(ar,ix,val) - assigns a value to array or diction
- mklambda - creates LambdaType 
- xmit(object, message) - sends Ruby message to object and returns its result.
