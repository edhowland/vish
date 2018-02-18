# TODO

## Todo: Use the require 'readline' in ./bin/ivs 

Also in Builtins read/readi/...
This works better for screenreaders.

See feature/readline.ivs

## TODO, make sure LambdaExit pops the FrameStack if there are any parameters

## TODO: MUST: c.lambdas is hash of tuples of lambdas, lambda_names

Need to take into account if lib/analysis/convert_funcall_to_lambda_call.rb

## Todo: Add hello banner to REPL: ivs

```
$ bin/ivs
Welcome to Vish. Version x.x.x
vish>^D

$
```


```
# supress this banner:
# in ~/.ivsrc:
banner=false
prompt='>> '

$ bin/ivs
>>
>>^D

$
```

## TODO: MUST: replace bin/ivs with bin/reader.rb once enough testing has been done

Problem: gem: tty-reader does not output an entered '['

### Todo: Once the above is done: move internal builtin read() to use this gem

## TODO: Rename lib/ast/ListType to ListNode

## TODO: Rename ast/ SymbolType to SymbolNode

Should have all types in lib/runtime/xxxxx_type.rb derived from Type

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


## Todo:  Allow named functions to be higher order function values:

If you dereference a function symbol, it should return a FunctionType. These
types can be passed to other functions/lambdas as parameters Or saved in a variable.

```
# simple case
defn foo() {'hello'}
fn=:foo
# now execute it:
%fn
# => 'hello'
#
# Now pass as a parameter
defn bar(fn) { %fn + ' world'}
bar(:foo)
# => 'hello world'
```

### Question: Can these be closures?

```
# this should work
defn mkfoo(x) {
  defn foo() { :x + 2 }
}
mkfoo(5)
foo()
# Should  be 7
```
## Todo: figure some way to handle nils

See kotlin language for advice on how to do this.

Also, in a stack-based VM, any assign returns nil because the stack is popped
and nothing is there. Should we push the assignment ther?

This works in Scheme and in Ruby.

```
x=9
# gets nil

# after change?
x=9
# gets 9
```

Note: This works in Ruby:

```
def mk_x
  x = 9
end
y=mk_x
p y
# => 9
```

##  Refactor function entries and function calls to use BulletinBoards

Currently, the way function targets are specifed is w/target_p, whcih 
returns a closure. Since we use BulletinBoard to resolve
lambda targets via/JumpTarget, this is a better method.


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



