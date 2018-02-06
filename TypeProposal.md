# Type Checking Proposal

## Abstract

Vish does not have compile time type checking. This proposal attempts to define
a possible path to that possibility. Vish does have a dependent kind of runtime
type checking.  It relys on the host language: Ruby to fail if an expression
if two or more types clash in the semantic interpretation of that expression.
For instance, if you try to add a String to an Fixnum, you will get a VishTypeError in the runtime.
Currently, these are caught only in the 'ivs' interactive Vish shell. All
other programs will just crash.

Type checking can be burdensome to implement and use in any programming
language. With Vish, since it is meant as a thin layer over your API
implementation , most of the work is of a prototype nature. As such, forcing
strict type checking just to try something out or in the command shell
of a text editor would seem to violate the spirit of Vish. Beyond that, 
implementing a compile type inferencer engine is probably hard.

Here, we propose to affect an optional middle ground: Type hints and Type 
checking out of band.

## Postfix Sigil optional typeing.

For this proposal, we aim to reuse the already in use prefix sigils as postfix type hints.

As a review, here are the currently implemented prefix sigils, and one not yet implemented one.

- ':' - Dereference a variable or parameter.
- '%' - Execute a lambda function pointed at via that variable.
- '~' - Create a object literal.

These very few prefix characters are only used to point out the compile that some
action is about to be preformed.

In addition thes prefix sigils, the following is reserved for future use:

- '@' - Expand a macro in place.


### The macro system asside.

We should take a momenet to explain what I mean about the macro system. Because
code speaks louder tan talk, please look at this:

```
# define a macro to be used later
defmac addr(a,s) { 5 + :a * 6 + :s }
# ...
# Now insert this in place:
result=40 / @addr(10,14)
# When compiled, this does result into a function call.
# It is just expanded in place, with the parameters substituted in place:
result=40 /  5 + 10 * 6 + 14
```

#### Caveate regarding the above expression.

The above @addr macro expansion happens with the AST at compile. Internally, any
infix precedence are already worked out. Your mileage might vary, if it is not
as you might expect.

## Postif Sigil hints

The following postfix sigils are proposed:

- ':' - Symbol. Currently in use.
- '%' - Variable, function or function parameter is expected to be a lambda.
- '~' - variable or function or one of its parameters is expected to be an object/dictionary.
- '`' - The variable is expected to be a list/array.
- '#' - Fixnum (Integer)
- '$' - String
- '?' - Boolean (Boolean expression or true/false literals)
- '!' Implication that function will change the state of one of its  parameters
- '*' - Any  type or some unkown type.

### Unused postifx sigil

- '@' - These get expanded at at compile time, so they cannot (yet?) be 
  be inferred in the type checker. You can just as easily pass the actual code
yourself.

### Notes on predicate/imperative sigils: '?'/'!'

There already is a convention for functions to use '?' as a trailing indicator 
hat it will return either true or false. So, you get that type checking for free.
There also a convention to use '!' as some signal to other programmers, that
this function will either change something one of its parameters that point to
something. It can also be ued to signal that the underlying Ruby runtime might or actually return a 'nil'
Used for type checking purposes, it can signal it should not be assigned or returned from a function.

```
# Assume, we implement a dispatch to Ruby's 'puts' method.
defn prnt!(msg) { puts(:msg) }
result=prnt('bad juju')
# During type check, this will trigger an error
# Or:
defn add1#(expr#) { :expr + 1; prnt!("debug: :{:expr}") }
# a check time type error is raised, because you told the compiler the add1 function is returning a Fixnum.
# It can be fixed by reversing the order of the two statements in the body of the add1 function
```

## Postfix sigil stripping

The actual postifx sigils are stripped from the variables, and function or parameters at compile.
So, in your source code you can use the functions and variables as if they were never there.
If you do not use strict type checking while compiling or,
the type checking will default to runtime checking only. This might lead to crashing of your programs.

#### Predicate/Imperative sigils are not stripped

The exception to the above is that functions, variables and parameters with with '?' or '!'
are part of the identifer's literal name. Thus, they are preserved in the runtime
and are significant.

```
# these two names are distinct:
ok?=%is_ok?()
ok=%is_ok()
```

You might then want to consider using the postfix sigils liberally in your 
function libraries. An attempt to create a kind of type metadata for use
in importing your client programs. It can also be useful for use in testing
as you can force the type checking to be doen at compile time via the further
proposed 'pragma' directive.

### Type hint combinations

You can combine these postfix type hints to be more explicit in certain cercumstances.
For instance, lets say you expect a function parameter to be a lambda that
returns an integer, you can combine bothe of these sigils.

```
# define a function that takes a lambda returning an int.
defn get_int(fn%#) { %fn + 1 }
# ...
f=->#() { 9 }
result=get_int(:f)
# Works! => 10
# Now, let's break it.
s=->()$ { "thing" }
get_int(:s)
# Throws VishTypeCheckFailure
# But, will still compile, and expect to break at runtime.
```

## Some examples

```
# fully qualified function declaration
defn foo?(anum#, str$, list`, obj~, bool?) { ...; true }
var=->(q?)$ { "ok :{:q}" }
foo(:var)
#
# lambda that takes an int, some imperative, and returns an int.

fn=->(n#, phi%!) { ...; 0 }
x=%fn(2, bar!)
y=%fn(3, baz)
# Note: Both of the above work. : because foo! is bothe that name
# of the function and the type hint.
# The y=  example also works, the lambda might change its world, or it might not.
# It will have no affect on the executation of the body of fn.
```

Note: The imperative example expects a possible imperative phi! parameter.
If compiled with the strict flag or strict pragma keyword, it will fail if given
any other type hinted, or the default UnknownType.

# The Any type sigil - '*'

The '*' sigil can be used to signify any type.

```
# add/or concat 2 things
defn combine*(a*, b*) { :a + :b }
combine(2, 3)
# => 5
combine('hello ', 'world')
# => "hello world"
# But:!!!
combine(12, ' days to go')
# throws a VishTypeError at runtime
# and will not be caught at compile time.


## Future Directions

### Pattern matching

Explicit type signals open an path for polymorphic dynamic dispatch. 

Consider the following sum_all function:

```
defn sum_all#([]) { 0 }
defn sum_all#(...args`) { head(args) + sum_all(tail(args)) }
#
result=sum_all(4, 5, 6, 5, 99, 32)
```
So, in addition to the explicit postfix sigil type hints, unnamed variables, or named variables with the
following type hints are allowed:

- '[]' - defn foo(list[]) { ... }
- '(int)' - Known integer constants: defn bar#(1) { 1 }

This could be extended to symbols, booleans or strings.

```
defn quote('') { ...  }
defn fubar?(false) { ... }
defn symbolic:(unknown:) { ... }


The '`' hint for args is superfullous, since the '...' ellipsis always signifies
the named arg is an array of the remaining arguments.