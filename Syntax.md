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


