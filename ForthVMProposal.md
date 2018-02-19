# Rewrite the VM using Forth-like interpreter

## Abstract

Currently, the Vish VM is written my own Ruby implementation. Although it has been pretty stable, there are 
to improve it. One idea is to make it work more like a Forth VM.

In Ruby's bytecode interpreter, it uses a threaded-like movement mechanism. After each bytecode instruction
finishes, it returns the next place to move the instruction pointer. This makes jumps
easier and moving sequentially it just automatically return the 
next spot in the bytecode stream.

The above archetecture is slightly faster and simpler than computing the next instruction on every pass
through the loop.

But, I propose to go the next full step. The compiler should output Forth strings
directly from the AST emit code. There are both advantages and disadvantages to this approach.

## Advantages

- Forth is a very well known and stable arch
- It is extremely fast
  * At runtime, both startup and program execution
  * And at compile time. (Very little parsing overhead and just linking words in the dictionary.)
- Very portable. This implementations for every OS/chip arch.
- Great debugging support. The REPL is very introspective.
- Self-documenting
  * AFAIK: comment nodes are stored along with words and can be queried.
  * The words can be decompiled at runtime. (Use of the see word)
- ANSI standard Forth should be compatible with other systems.

Note: Output of the Vish compile step can just be writing Forth codes to the .fs files (we can call them for .vsc files.)

We can embed function names (and even Vish documentation nodes) in Forth comments.


## Disadvantages

It is easy to crash the forth vm.

I am not sure I can duplicate the lexical structure of closures.
See below for a larger discussion of this part.

## Proposed implementation

The Forth dictionary dictionary looks a lot like the existing BindingType.
A serries of PairType nodes connected in a cons list.
This data structure can be walked iteratively instead of recursively.

### Node/Word types

Each word consists of a Pair of key: word symbol and value : cons list ofwords that make up
the word definition. The :";" symbol gets replaced with
a word return token. (Pair key, empty value.

In the cons list, each pair consists of the word token key, and value of the actual
pointer in the dictionary top level.

Some tokens will be immediate execution tokens

- Numeric literals
- String literals
- Primitive operatives.



### Current existing infrastructure.

Forth maintains a call stack and a data stack. The call stack contains the return address.
The data stack is probably the same as my data stack. So, no changes herein.
Forth does similar things with loop frames as Vish does.

Forth has memory allocation similar to my :alloca method. and my :pusha fetch from the heap.

### Additional components

There will have to be a Forth compiler.
This should be written as a separate REPL. It should prepend to the builtin 
BindingType-like Dictionary.

Immediate execution stuff will have to be interpreted directly.
Consider the following Forth word: sqr

: sqr dup * ;

The :dup and :* are builtin symbols.
In Ruby , we can use a Hash table for these. And check for .has_key? :dup.
If it exists, call the proc therein.

### Interpreter Loop

loop 
  # Look up the current word in the dictionary
  If it exists
    if it is a word and not builtin
    Move the pointer to the value member of the pair
    else  if It is builtin?
    perform the operation
    else if it is immediate
    push it on the stack.
  else
  report error
  end
end

Note, the :halt operation raises the StopIteration exception

### Closure definition and implementation

Propose to remove the :jmp, :jmpt and :lcall, (but not the :icall) byte codes.

```
defn foo(a) { :a + 1 }
# compiled into:
: foo 1 + ;

foo(3)
# compiled into 
3 foo
```

This is direct compilation of Vish functions into Forth words.
Very to get right and test/debug!

#### Caveat with this approach

Notice there is no local parameters into variables in Forth.
Everything is expected to be on the stack.
This breaks the closure <-> binding interaction.

Consider this code:

```
fn=->() { 100 * 4 }
defn foo(f) { %f - 100 }
foo(:fn)
```

I do not think you can push a word onto the stack
and then pop it off and then execute it.

Also, we need to store the current binding on the heap.

Can we get/dump the variables and store them in a Forth variable?
Can we also store the symbol of the Forth word.

I suppose that when we compile a Vish function, it can have function entry code, that
works like the current LambdaEntry stuff.
Currently, we have :set words to to store these in the BindingType data struct.
This could act as the v ! version in Forth.
We can create a :at word that corresponds to the '@' word in Forth
to push the value on the stack.

When we do '%f(2)' That can be expanded
into

```
( LambdaType is on top of stack)
at value ... Immediate code execution
# Where the value word is a builtin that extracts from PairType
```

