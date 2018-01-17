# Vish Language syntax

## Abstract

Vish is a simple language. It tries for a simple
syntax and get out your way. Since it drives the Viper editor for blind and
and visually impaired programmers, it attempts to make most things work on
a single line expression.  Users of screen readers often need to concentrate
a single line of text. So writing short, expressive functions and expressions
work to make life simpler and easier to compose small atoms of code into
larger levels of abstraction.


This documents is a place to encapture the details of the syntax of the
language and provide some aspects of the semantics or behaviour of terms
in the language.


## Atoms

Vish has just a few atoms which are the result of computing an expression.
Atoms can stand-alone, be assigned to a variable or passed as a parameter
to a function.

- Integers - integer literals like 0,1,22,999 .etc
- Strings - strings can be quoted 2 ways
  - Single quoted strings: E.g. 'hello world'
  - Double quoted strings - E.g. "This is a double quoted string"
- lambdas - Anonymous functions : ->(arg) { :arg + 1 }
- Blocks - small contained units of program statements.

Double quoted strings are also possible interpolated strings.

## Sigils

Vish uses several sigils (single ASCII characters) to represent different type 
of expressions:

- colon ':' - Used to dereference a variable or parameter.

## Program

A program in Vish is 0 or more statements or comments delimited by new lines or semicolons.

```
# This is a comment to the end of this line
# below are statements. All are equivelant:
x=2+3
y=:x + 4
x=3 + 2;y=:x + 4
```

## Statements

A statement is:

- Any valid expression
- An assignment. The rvalue of an assignment can be any valid expression
- A block which contains more expressions/statements.
- A function declaration
- A function call. (Either a builtin or user defined function)
- A lambda call.
- A block execution. This differs from a a inline block.

## Expressions

Any valid expression can be executed as a statement or assigned to a variable
or passed to a function/lambda as a a parameter.

Expressions can be infix operators with lvalues and rvalues. Lvalues
can be literals or variable dereferences. Rvalues can be any valid literal or
other valid expression.

Here are some valid expressions:

```
1+2
3*10+4
:x/:y+2
:li[2] - 14
sum(:li)
# result of calling a lambda: with result of calling a function
%lm(foo(:x))
```

## Collections


Vish has 1 collection type: List

### Lists

Lists work like lists in Lisp. They can be created, recursived over, extracted,
and be combined into larger lists.

```
# a simple list
l=[0,1,2,3]
:l
# => [0,1,2,3]
:l[2]
# => 2
head(:l)
# => 0
tail(:l)
# => [1,2,3]
l=list(:l,[4,5,6])
# => nil
:l
# => [0,1,2,3,4,5,6]
```

## Functions

Vish has named and anonymous functions or lambdas.
Functions can take parameters and return the last expression evaluated.

Functions are created via the 'defn' keyword. Followed by an identifier, 
an optional list of parameters surrounded by parenthesis and then a block of
code surrounded by curly braces:

```
# a very simple expression to add three parameters
defn foo(x,y,z) { :x + :y + :z }
#
# A slightly more complex, but absurd function
defn bar(n,l) {
  tmp=:l[:n]
  [:tmp]
}
# now lets call it:
l2=['hello'];bar(0,:l2)
# => ['hello']. It is unchanged!
```

## Lambdas

Lambdas are anonymous functions. They can be saved in a variable or  passed as 
a parameter to a another function. They can also be returned from a function.

A lambda is construction like a named function but using the '->' prefix.

A lambda can be called via use of the '%' sigil prefix on the named variable or
or parameter. If lm is a lambda expression, %lm() will call it.

```
# a simple subtracter
sub=->(i,j) { :i - :j }
# Now call it
%sub(9,3)
# => 6
```

### The return keywor

Although not recommended, a function or lambda can return early from a function via the return keyword:

```
# Returning early from function
defn baz(x) { :x == 10 && return false; :x + 1 }
```

### Passing lambdas to functions

A lambda can be passed as a parameter to any other
function or lambda.

Here is some code that implements the map higher order function from other languages:

``
# map.vs - implements map method over list applying fn for each item, returning
# new list with each element doubled.
defn map(li, fn) { 
  (:li == []) && return []
  list(%fn(:li[0]), map(tail(:li), :fn))
}
map([1,2,3,4], ->(x) { :x * 2 })

```



## Blocks



In Vish, blocks are first class citizens. They can be executed inline, saved in 
variables or passed to functions.

Blocks are delimted by curly braces

### Inline blocks:

```
# this is a simple block
{ hello='hello'; world='world';print(hello + ' ' + world)}
```

### Block expressions

As rvalues blocks can be assigned to variables or passed to functions/lambdas
as parameters:

```
# saving a block to a variable:
blk={4+3}
# Calling it:
6*%blk
# => 42
```

### Blocks as parameters

```
blk={:x/2}
defn foo(x,bk) { %bk }
foo(100)
# => 50
```
