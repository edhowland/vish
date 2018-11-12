# Notes

## 0.6.3-1 Improve TCO

Rules

- Entire block of :lambda is in tail position.
- Last child of :block of :lambda is in tail position.
- If last child is:
  * :lambda_call : Ripe for TCE
  * Conditional in last child
    - All legs of conditional are also in tail call position
- Non-lambda calls/conditionals are not in tail position.
- A block in last child is in tail position. Recur on block above.

Therefore, we recursively define each leg according to these rules.

Any left childs of a conditional are not in tail position, unless they are a block.
Then only the block rules apply.

You would expect to have a predicate happen in left child. Since it still has
work to do, you would not like to leave the function body and not return.

However, if you have a nested conditional, and a lambdacall occurs in the upper
left child, but inside the right child, then it is a tailcall. (Only if it is
inside a lambda body.)

```
->(x) {
  {zero?(:x) && %g} || %f
}
```

In the above example, both %g and %f are in tail position. but zero?(:x) is not.

Final observation, Any return expression, apply the above rules. Because it is 
by definition in tail position.

This is not true for returns outside of Lambda blocks.

## Porposed version 0.6.3: Continuations

Subclass of LambdaType is Continuation.

New instance is created with _mkcontinuation taking a stack frame.
This is reified via the __frames() method

The result is passed to _mkcontinuation and returned  to the lambda passed to
callcc : defined in std/lib.vs.

Tests in test/test_continuations.rb

## Version 0.6.2

### Tail call optimization

To activate tail call optimization: TCO:
Use the --tail_call flag for the vishc executable. Or, set it to true in

```
VishCompiler.new.default_optimizers[:tail_call] = true
#
This enables it at runtime. Otherwise, recursive calls will consume stack space.


To ensure your code is setup for tail calls when doing recursion, ensure
that the recursion is the very last call in the function body.

```
# How to do factorial wrong:
defn fact(n) {
  :n == 0 && return 1
  :n * fact(:n - 1)
}
# The above has more work to do after the call to the fact(:n - 1)
#
# Do it right with an auxillary function with accumulator passing style
defn fact(n) {
  defn aux(n, acc) {
    {:n == 0 && :acc} || aux(:n - 1, :n * :acc}
  aux(:n, 1)
}
#
# The :acc gets calculated and passed on the next recursive call to aux()
```

This version is properly tail recursive because the calls to the first aux(:n, 1)
is in the tail position, and the recursive call within aux() is also
in the tail position with aux(:n - 1, :n * :acc).
### Semantics of if/then/else

To get the effect of a if, then and else  clause, do this:

```
# if/then/else
{ 4 < 2 && 'less'} || 'greater'
# => 'greater'
{ 2 < 4 && 'less'} || 'greater'
# => 'less'
```

## Version 0.5.0

Changes the semantics of named function declarations to use lambda assignments
instead.

E.g.

```
# This:
defn foo(a, b) { :a + :b }
#  becomes:
foo=->(a, b) { :a + :b }
# But, this still works:
foo(2,3)
# => 5
```


## Let binding

### The loop over closure problem

If you create a loop and then save a bunch of closures over some internal changing state
and then later execute these lambdas, they will all have the same state that existed
at the time the loop exited.

See this example:
... compiler/missing_let.vs

At the end, we try to execute each closure in :set. But they all the same environment pointer.
It has the last saved value in the :i variable. So, they all print the same value.

### Possible solution

Was known for a long time in Lisp/Scheme language designers.
So, they introduced the 'let' binding.

```
# possible Vish implementation of let:
set=list()
let(a, b, c) {
  cons(->() { :a + :b + :c }, :set)
}
# now execute the closures.
map(->(x) { %x }, :set)
```

'let' here introduces a new binding for the variables on the frame_stack. It is sort like a
function call, but one that is executed in situ.

If this existed in a loop body, then it would look like the function was being invoked anew
everytime. Therefore, each lambda created on the heap would point a new Frame.

### In Scheme/Racket: can set variables in let binding.

```
(let ((a 2, (b 3) (c 4)) 
  # some code
)
```

### Note: This also applys to current problem of not shadowing parameters
in lambda function calls.

This problem may be solved in the compiler phase somehow. See shadowing.

However, if you want local variables in your lambda (or a actual function with
'defn', you would need a let binding.

```(Ruby)

```

## Variadic method signatures

Function calls already take a variable number of parameters. But at runtime,
they only consume the arity of their signatures on the stack from the top down.

```
defn takes2(a,b) { :a + :b }
takes(1,2,3,4,5,6)
# => 11, because 5 + 6 is 11
```

This is a failure of not doing enough compile time checking.

What should happen is in the function_entry thing, to collect all the remaining 
arguments into a :_rest variable in the current frame as a list.


## Blocks are 0 parameter Lambdas

1. Turn extract_blocks to create VishCompiler.lambdas hash.
2. As is done in extract_lambdas: Replace '%blk' with LambdaName


## The xmit builtin - Transmit method

Mostly for debugging, a wrapper around the object.send method.
Use a string for the method argument:

```
# get the length of a list
list=[0,1,2,3]
xmit(:list,'length')
# => 4
```


## Closure implementation:

1. Lambdas are closures. A single structure containg the arity, the body bytecode offset and the current frame
2. This actual object is stored on the heap.
3. Nost Importantly: When executing the lambda, instead of
creating a new FunctionFrame, the saved frame object is pushed on the VM's frame stack.

The advantage is any variables created within the body
share the same environment as theprevious exectution environment.

Any new variables are not seen outside the lambda body because
there is no reference to them


## Notes about VM construction from YouTube channel: Jephthai

Should the opcodes always return the next ByteCode pc to go to?
Is this simpler?

If actually was a real bytecode list of opcodes actually 1 byte in length,
unused interies in the table could point to nop function which will just
to next instruction.


## Change of filename extension : .vs, was .vsh

Reason for change: Syntax differences between this version
of Vish rather Vish version 2.x. The later has .vsh file extensions

- .vs - source for Vis v3.x code
- .vsc - Compiled .vs code
- bin/ivs - Interactive Vish REPL shell
- vish - Compiles and runs .vs code
- vishc - compiles .vs code into .vsc bytecode
- vsr - Loads and runs .vsc code
- .vasm - Assembly code for .vsc code
- vasm - Assembles .vasm code into .vsc code for vsr runtime
- vdis - Disassemblies .vsc into .vasm code for inspection and fixup
- .vson - JSON output of AST capture

The latter extension can be used with either vishc compiler or ivs interactive shell.

```
$ vishc -c file.vs
# Will compile only to file.vson

$ vishc -o file.vsc -l lib1.vson -l lib2.vson file.vs
# Will compile file.vs, linking lib1.vson, lib2.vson into final output: file.vsc
```

## Possible fix to repl.rb

Munging source with previous code blocks, lambdas and functions is too 
wacky. Not sure if all the target locations can be safely found in output.

Better way might to just maintain a very large source string and just
recompile it every time

Tricky part is to do a semicolon append to every entered string.

Alternatively, parse and transform upto the AST and just merge the ASTs before 
doing analysis and code generation

# Will 

### Notes on linking up multiple source code blocks

Several .vsc code blocks can be loaded together
into a single application.
Great for code libraries, code modules, .etc.



## User defined functions


### Implementation

```
defn foo(a, b) { :a + :b }
defn bar(n) { foo(:n, 2) + 3 }
bar(9)
```


In analyze: use reduce({}) on list of UserFunction selected.
The resulting hash should store the key,value pair as the name of the function
and the node name (its location).


```
@functions[:foo] = 'UserFunction_22'
```

#### Step 2: Change Funcall s to UserFuncall s

select from ast where the content type is Funcall
If Funcall.value in @functions
then
  Replace with UserFuncall with reference to UserFunction object

#### Step 3 : Extract all the UserFunction bodies.

?? Do we have to replace them with Nop's?

Note: We must memoize the actual FunCalls which actually refer to functions.
These can be removed before bytecode emission.
Sort of a mark & sweep algorythm.

#### Step n ??? ByteCode layout:

For UserFuncall emission, the name of the AST node should be laid down 
after the :fcall opcode. I.e. UserFunction_22:

```
[:cls, :fcall, 'UserFunction_22, :halt] # ... more bytecodes
```

#### Step (Penultimate)

After laying out the @function_bodies, their locations will have been stored 
in their UserFunction instances.

Walk through bc.codes, replacing :fcall, 'xxxx' with :fcall, 90, ...

##### ??? Will this work with recursive application

## Debugging

Must implement some kind of capture of the stack frame in case of an unrecoverable error.
working on the assumption that this will be an exception handler.

## Interrupt handlers.

Since when an interrupt occurs, there is a hardware level (virtually, at least) context switch.
The program counter jumps to a new position on the hardware firmware stack.
When it returns fromt eh interrupt, it doesn't know from whence it came from.
Therefore, the controlling jump: :int, must position the 
returnning PC. by incrementing it one offset. After the context
switch occurs and the original context is popped off the code stack,
The original PC is ready to resume with the new next instruction after
the :int opcode and its operand.

This differs from function calls which must place an entire activation frame on the call stack.


### Change this mechanism to :int0, :int1, ... :int9.

This removes the operand, and allows for breakpoint insertion at any pointw/o
messing any jmp targets. 

### INT codes

- :int0 : The default int handler
- :int1 : Reserved for break points
- :int2 : unused, 
- :int3 : Unused
- :int4 : Unused
- :int5 : Unused
- :int6 : Unused
- :int7 : Unused
- :int8 : Unused
- :int9 : at_exit lambda chain

The latter :int9 allows for the following syntax:

```
at_exit(->() { return 1 })
# ...
at_exit(->() { print("exiting...") })
# upon exit of the script:
# Exiting
# $? == 1  # the exit status of the script
```

The internal 'at_exit()' function should store the lambda references in an exit lambda list: []
stored in the heap.

Note: This will require that :icall will have to pass the heap to any internal functions. (Via the heap: keyword?)

### The exit status:



## Exception handling: catch/snag

catch is like try/begin. 
... Also like catch/rescue
Snag is like throw/raise


The intent is to be intentional. We attempt to catch some vish.
If we are lucky, we snag some on our net.

So the metaphor is net fishing, not ball throwing. Or try/catch
which I think is not pretty.

E.g.

```
# attempt to catch some vish
catch { s1; s2; snag 'nemo'; s3 }
s1
s2
Caught: nemo!
```
Snags might be deeply nested. So, since they are merely interrupts,
they must unwind the call stack.

Users can install 2 additional blocks to handle
the result. Snarkly, we can call the caught block: dinner. And the
finally block block: dessert. :)
But in the grammar, they are unlabelled.

E.g.

```
# eat some of our catch
catch { s1; snag 'flounder'; s2 } { echo("Yum! engjoying: :{caught}") } { echo("after dinner drinks") }
s1
Caught: Yum! Enjoying some flounder
after dinner drinks
```

Because, we can never miss dessert, even if we caught nothing.

### Implementation:


--- Or they merely :jmp there. ---

The snag keyword, performsan :int, :_snag interrupt.
It first must place its argument on the stack.
The interrupt handler for :_snag unwinds the call stack until the most recent catch block .

It must somehow get the compiled dinner block block address.
???

## The REPL

Currently, the repl is recompiling the entire runtime complex each pass through the loop.
What should probly happen, is the entire AST should be saved through the loop pass.
In the parse phase of the VishCompiler, the ast should just be appended to. 

In order to make this happen, we must not create a Start, Final AST node.
The Final  AST node type is not really needed any.
The :halt must still be placed after the main body of the code is generated.
The preceeding :print opcode becones unnecessary.

This cannot happen in the current configuaration because the new codes
on pass 2 ... Infinity can not be appended to the past the :halt
and any possible Block nodes.

This should be possible with storing the saved blocks in VishCompiler.blocks array.
Also, the $node_name bmust be allowed to continually increment
to keep creating unique node names for rubytree reasons.

## Blocks

Blocks : { statement_list } are first class citizens.
They can be assigned to variables, passed as arguments to functions, etc.

But they can also be invoked, IOW they can be deferred code.

```
# Assigning a block to variable
var1={ 3 + 5 * 10 }

# Assigning the result of calling a block to variable:
var2=:{ 3 + 5 * 10 }
:var2
53

#executing the deferred block
%var1
53
```

The syntax of :{ expr } is the same as that used
in string interpolation.

The syntax: %{ block } means execute this block at this point of the program.
If the block has been placed in a variable, or passed to a user function,
using the '%' will execute at that point.

Internally, the deferred bock is stored as a Block instance. This is stored in Context.constants
when a '%' is encountered, instead of the normal :pushv, :varname being performed,
it still happens, but an extra instruction :exec is 
run just after this. :exec grabs the top of the stack and
runs the bytecodes within there in a new Context
instance that shares the .vars framestack.
The final stack result of the Block instance is pushed on the current stack.

## How to spell Exponentiation

exponentiation


## Notes on string interpolation

In parslet lingo: the 'any' atom is equivalent to '.' in regular expressions.

Need to recombine any escape_seq :escape, and :strtok (single chars) into combined strings where the escape sequence is 
converted into appropiate characters.

In Ruby, the interpolated bit: #{ expr } can be deeply nested with even more strings with interpolations with more 
#{ expr2 }, et. al.
Double quoted strings can contain strings, escape sequences and language expressions.
A fully realized string processor would work in two steps:

- escape sequences would be transformed into their binary equivs at compile time.
- Language expressions would be interpertered at runtime  and replaced in the resulting string.

All these bits would be compiled along with the string literals at runtime to form
the complete resulting string.

The language expressions would be actually be parsed at compile time and any syntax errors raised.

### Examples in Vish:

```
# empty string
""

# non-interpolated string:
"this is a string"

# with escape sequences:
"This is line 1\nLine number\t2\nA line with backspace, cr and newline\b\r\n"

# Complex example:
v1=4+3*10
v2="helper"
final="The result of v1 is :{v1}\nThe value of v2 is :{v2}\r\nA complex expression:\t:{:v1 / 33}\n"
```
