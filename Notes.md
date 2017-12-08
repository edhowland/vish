# Notes

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

The catch block must be :bcalled into preserving the return location
on the call stack. The end of the catch block must :bcall into the dessert block.  
The end of the dinner block must also :bcall into the dessert block.

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
