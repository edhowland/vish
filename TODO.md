# TODO

## Completions
```
# passing as an argument:
my_func(:block)
in my_func
ok

# in my_func()
function my_func(blk) {
  echo('in my_func')
%bl}
```

The variable block is dereferenced in the funcall: 
( this behaviour currently works, if you can save a CodeContainer in named :block variable)
Then this item on the stack is bound to the argument vairable :blk in 
the new frame stack.
After in the body of th function, it is dereferenced as aboove in the top level
context.


### true and false in vasm, vdis.rb

Remember to handle this thing in asm/vasm.rb, vdis.rb. Will assembly decod in vasm_grammar recognize these strings or not.

### Add randomizer, Ruby expression to testing of test/test_compiler.rb

The idea here is to use Ruby to chack the result of evaluating the generated
bytecode from the compiler step:

```
bc, ctx = compile '5*10+100/2'
ci = mkci bc, ctx
ci.run
assert_eq @result, 5*10+100/2
# Should be true
```

#### Randomizer

This is type of fuzzing the input.
Assume some form of random expression generator, like in a Ruby Fiber.
It should return a string of random numbers up to 100, and a choic of operators among +, - and *. (/ or divide is left off to prevent rantional
results, only integers any on the number line.
E.g.

```
rando.times do
  expr_s = random_gen # like '4-20*1+5'
bc, ctx = compile expr_s
ci = mkci bc, ctx
  ci.run
  assert_eq @result, eval(expr_s)
end
```

### REPL should consume any parser syntax exceptions and just say "Syntax Error"
Giving the line, col numbers and the Parslet message top line

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