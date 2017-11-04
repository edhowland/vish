# TODO

## Completions

### Add symbolic labels to assembly source for jumping

```
# sample source
...
codes:
cls
pushc 0
pushc 1
and
jmpt lbl001
cls
pushc 2
jmp lbl002
lbl001:
cls
pushc 3
lbl002:
print
halt
```


### Implement ==, !=, &&, || and ! operators in Vish grammar


### REPL should consume any parser syntax exceptions and just say "Syntax Error"

The syntax error can be logged in a logfile or in a variable in the VM ???

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