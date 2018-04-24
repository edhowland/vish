# TODO

## TODO: Replace all occurances w/LambdaType for NambdaType

Note: Must ensure that lambdas are captured by compiler and
adjusted back to of bytecods during code emission.

Note: Ensure anonymous lambdas get lambda ids for use in code emission.
This is to ensure we do not recreate multiple instances of the code blocks
when we call a function that returns a lambda. The binding is new and a new object
but the code block is shared.

## Todo: Make sure predicate of lambda? works in s-expression land

## Todo: Improve string interpolation

Currently, every character is an individual strtok For even short strings,
this explodes the bytecode to perform a call to 'cat' builtin function.

There should be a regular expression that captures the string run lengths 
of contiguous strings upto escape sequences and %{ vish-expression } s.

### Todo: Better syntax checking for string interpolation internal expressions



## Todo: Derive a way to make variadic arguments to lambda def/call work.

Should somehow be part of function signature. Needed for type/program correctness


```
# a variadic signature:
defn foo(a, b, c&) {
  :a # is single value
  : b # as is b
  :c # => [rest of args
}
# now call later
foo(1,2,3)
# => [3]
```

## Todo: Allow builtin functions to be passed in and out of higher order functions.

The way to do this is via proxy variables. Each stands in for some  builtin function.

```
length([])
# => 0
:length
# => LambdaType :builtin, name: length, arity: 1
```

This includes Builtins, and any Ruby FFI functions linked in.

Will require the intended Ruby FFI modules to be supplied to the vishc
compiler ahead of time.

## Todo: Create 'curry' method

Takes a function as one argument (for now)
Returns new function that can be partially evaluated over its arg list.

Actually kind of clones the LambdaType

```
defn foo(x, y, z) { :x + :y * :z }
bar = curry(:foo)
baz=bar(1)
# => LambdaType
qux=baz(2)
# => LambdaType
qux(3)
# => 9
```

## TODO make command history work in ivs REPL

## TODO: Add let binding





## Todo: Make the return statement allow to convert blocks to lambdas.

Normally, you can not return a block from a function. It just gets executes
in place as an inline block.

But by preceeding it with a return keyword, it can be promoted a lambda.

E.g.

```
defn mkblock() {
  n=6;m=7
  { :n * :m }
}
y=mkblock()
# => 42, not a LambdaType
#
# After the improvement
defn mkblock() {
  n=6;m=7
  return {:n * :m}
}
y=mkblock()
# => LambdaType_xxxx
%y
# => 42
```


## Make block instances become inline, wherever possible

Currently, blocks exist outside of the main code instance.
There stored in the VishCompiler.blocks array.
This should become a Hash like .functions/.lambdas.





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


## Completions


### Loops

#### Keywords

Add the following keywords:


Add the following builtins


Later, we will have to handle exceptions ourselves.


# in my_func()
defn my_func(blk) {
  print('in my_func')

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
import vishlib,http,net

... # other statements

```

This is the same as using the ./vishc.rb to stitch various .vshc files together at compile time.
It can be specified within the individual source files.

This also helps the compiler check for unreferenced things.

## Todo: Create   a type mechanism

Types tag their objects with the type parameter

Should some Ruby metaprogramming to dynamically create from a string/symbol.

### Types are syntax sugar for creating constructors out of objects.

```
# define a type:
deftype MyType(a, b)
# => Type::MyType
# use the type:
myt=MyType(1,2)
typeof(:myt)
# => Type::MyType
typeof(MyType)
# => FunctionType
%myt.a
# => 1
%myt.b
# => 2
```

Internally, the AST gets expanded to create an  function with the name of the type name.
Internally, it will have an ObjectNode with  with lambdas for getting/setting each parameters
of the type definition.



