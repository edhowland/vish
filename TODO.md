# TODO

## Pipelines can be used with parameterized placement in arg list

Like in JavaScript ES8, use of the ? parameter to place the top of 
the stack in positional placement:

```
# Normal pipeline
defn foo(x, y) { :y * :x }
4 | foo(2)
# => 8
defn bar(x, y, z) { :x * :y + :z }
10 | bar(3, ?, 4)
# => 34
```


## Closures must not be created for local variables within lambda body


## Ensure:

### Check for  variables not set at compile time:

```
var=:name
CompileError: :name is not set yet
```

do this in VishCompiler.analyze phase

### Support for evntual closure stuff.

In the analyze phase, the AST can find unbound variables in subtree nodes.. If any exist in
lambdas, it can mark them for special runtime dereferences.

any other variables will be reported by the compiler.

## Completions


### Loops

#### Keywords

Add the following keywords:

- print - emits :print

Add the following builtins


Later, we will have to handle exceptions ourselves.


### Blocks:

```
# passing as an argument:
my_func(:block)
in my_func
ok

# in my_func()
defn my_func(blk) {
  print('in my_func')
%blk}
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


### Add -j, --generate-ast to compiler/vishc.rb as options

The idea is to save the AST as JSON.
This can be accomplished with rubytree gem: .to_jsom

Add the ability to vishc.rb to also read these in from the option time and
append the nodes to the root of the eventual bytecodes.

#### Also implement the import keyword:

```
import 'vishlib'

... # other statements
```

This is the same as using the ./vishc.rb to stitch various .vshc files together at compile time.
It can be specified within the individual source files.

This also helps the compiler check for unreferenced things.