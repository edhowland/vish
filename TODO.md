# TODO



## Completions

MUST: Have some syntax for .vasm files to add Context stuff
Should load .constants array and .vars hash
Proposed syntax:

```
constants: 100, 33, 99, 45, 20
vars:
  name=13
  var2=44
  var3=55
# end of vars
```


The vasm syntax will keep reading vars until no more indented lines, like in .haml
## Additions:

Add in the thor gem from Yehuda. This
will provide a nice wrapper around various things you can do here

- asm : assemble bytecode
- dis : disassembly of bytecode
-  parse : parse a string, checking for expected output
- transfrom : transform a Parslet IR Hash into AST
- walk - Walk the compiled AST
- compile : full compile into bytecode
- gen : generate assembly for bytecode
- emit : Walks the AST emitting bytecode
- interpret : load a bytecode from stdin or file and run it

Eventually funcall in Mini class to change from puts(1,2) to 'puts 1 2'make ast_transform.rb in


## Use of the highline Class is HighLine

This gem might not be all that useful.