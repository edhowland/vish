# TODO

## Todo: Must improve SexpTransform to convert import/export  and pragma

into S-Expressions

## Todo: Add notes re: creating your own Rakefiles

Note how you can load the /path/to/vish/bin/vishc in your Rakefile
Then, you can call the compile function and save the compiled bit if the result is true.

Note: You can make your own vish.erb and use vishc -R --template my_vish.erb -o myvish_target.rb myvish_target.vs
This can be used to get the full path to the vishc binary to use 
in the Ruby 'load' call.

```
# Rakefile

load %x{./myvish_target.rb}

task :compile do
  compiler, result = compile(compose(File.read(t.source)))
    abort("Failed to compile #{t.source}") unless result
  save(compiler, t.name)
end
```
## Move all meant for lib/runtime/builtins.rb : module Builtins from VishMail:util.rb

## Todo: Provide new flag to vish runtime to not do final inspect

Normally, the last instruction executed is inspected. Ok, whenever simple
testing .vs scripts.

But, by the -P, --no-inspect flag, do not output final instructio executed 
inspected on top of stack

```
$ cat test.vs
# test.vs compute 3 + 4
3 + 4
$ vish test.vs
7

$ cat print.vs
# print.vs - print something
println('ok')
$ vish print.vs
ok
nil
# latter 'nil' return value of println function call
$ vish --no-inspect print.vs
ok
$
```


## Todo: Change return code for frm - if it does not exist or problem removing file.

Currently returns 1 if Ok, false otherwise.
Should be at least true. Or tuple of status with reason ...
Make sure can handle in Vish language semantics


## Todo: Add more escape sequences into string interpolation

- "\e" - Escape character
- "\b" - Backspace character
- "\r" - Carriage return
- "\s" - space character


The remainder characters are already encoded:

- "\t" Tab
- "\a" :bell

Insert new escape sequences in lib/parser/vish_parser.rb:
at this line: ~118
  # TODO: make room for hex digits: \x00fe, ... posibly unicodes, etc

Note: Should require any code generation changes. Reuses Ruby to transform
actual sequences.




## Add sh function to Builtins module

```
vish>sh('echo hi')
hi
vish>
```

Find in Vishmail: util.rb module Util

## TODO : MUST create load function

```
defn load(fname) {
  fread(:fname) | parse() | _emit()
}
```

## continuation stuff

### Testing

create test/test_continuation.rb

## Todo: :halt and :exit are redundant

Probably should mae :exit just raise HaltState, unless someday  we want to return exit codes.


## Todo: Improve string interpolation

Currently, every character is an individual strtok For even short strings,
this explodes the bytecode to perform a call to 'cat' builtin function.

There should be a regular expression that captures the string run lengths 
of contiguous strings upto escape sequences and %{ vish-expression } s.

### Todo: Better syntax checking for string interpolation internal expressions



## Todo: Derive a way to make variadic arguments to lambda def/call work.

Should somehow be part of function signature. Needed for type/program correctness

### Negative arity

Currently, the :arity member of the LambdaType structure is 0  .. n
It can be manually changed to -1 and the :ncall with not error out when called.
This is used to support the lambda proxies on built in functions and FFI 
functions, since they have unknown arity and many are variadic. E.g. cat, print, list etc.

The _mklambda should have a way to set this or override its calculation.

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



