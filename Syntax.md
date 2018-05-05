# Vish Language syntax

# TODO: Incomplete documentation:

- Control statements

## Version 0.5.1

This document is complete as far as version 0.5.1  of the Vish language.

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

## Reserved Keywords

The following keywords have special meaning to Vish and cannot be used as identifiers or
function names:

- loop - Sets a loop that infinitely runs its block argument.
- break - Breaks out the innermost loop it is encountered within.
- return - Used only a function or lambda body to exit early with some value.
- exit - Exits out of the program from whether it is encountered.

### Reserved keywords for future use:

The following keywords are reserved at the present time, but will throw a
unknown  keyword at: compile time. (but will parse ok internally.)

- pragma - Expects a string that will be passed to the compiler or runtime. (TBD.)
- import - Expects a list of symbols that will be referenced in this translation unit.
- export -  Expects a list of symbols that will be exported to other translation units.

## Atoms

Vish has just a few atoms which are the result of computing an expression.
Atoms can stand-alone, be assigned to a variable or passed as a parameters
to a function.

- Booleans - 'true' and 'false'
- Integers - integer literals like 0,1,22,999 .etc
- Strings - strings can be quoted 2 ways
  - Single quoted strings: E.g. 'hello world'
  - Double quoted strings - E.g. "This is a double quoted string"
- Symbols - identifiers with a trailing colon, like keys in JSON strings. Symbols can be used as keys to objects.
- lambdas - Anonymous functions : ->(arg) { :arg + 1 }
- Blocks - small contained units of program statements. Blocks as atoms are lambdas with 0 parameters.

Double quoted strings are also possible interpolated strings.

### Strings

A string is any length of characters within either a double quotation or apostrophes or 
single quotes.

Strings are true to the predicate: 'string?()'
Strings respond to the 'length()' function
Strings can be concatenated with either the 'cat()' method or by using the
'+' infix operator
Strings also respond to the '*' multiplication infix operator. In this
case the string is repeated by the number of the integer on the right of the '*'.

```
'H' * 5
# => "HHHHH"
```

Strings can be indexed if there first stored ina variable. Acting like a vector

```
val="Sometimes"
:a[0]
# => "S"
#
# Can also assign to this position
a[0]="s"
# => "something"
```
#### Single quoted strings
A single quoted string is any number of characters inside 2 apostrophes.

```
# a single quoted string:
'My name is Sam'
# => "My name is Sam"
```

There are no allowed escape sequences or string interpolations within single
quoted string. For these, use double quoted strings.

#### Double quoted strings and string interpolations.

Here are some possible double quoted string examples.

```
# Simple string
"hello world"
# With escape sequences
greeting="Hello world!\n"
# With interpolation.
name=read()
print("Hello %{:name}. How are you?")
# => Hello Mary. How are you

```

##### Escape sequences.

Here the valid known backslash escap sequences in a Vish double quoted string.

- "\n" : Newline
- "\t" : Tab character
- "\a" : Sound the system bell.
- "\\" : Backslash character
- "\'" : single quote
- "\"" : Double quote


##### String interpolations with Vish expressions.

A string interpolation consists of the following elements:

- '%{'
- Valid vish expression
- '}'

This should occur within a double quoted string literal.

```
"5 times 10 is %{5*10}"
#
"it is %{3 < 4} that 3 is less than 4"
# => "It is true that 3 is less than 4"
```

## Sigils

Vish uses several sigils (single ASCII characters) to represent different type 
of expressions:

- colon ':' - Used to dereference a variable or parameter.
- Trailing colon - identifier + ':'. Used to refer to symbol.
- Percent - '%' - Used to execute a block or lambda
- Tilde - '~' - Used to create an object/dictionary

### Future reserved sigils

The following sigils are reserved for a future implementation of the Vish compiler.
They are mostly syntatic sugar for more explicit method calls.

- '^' - The key member of a PairType variable.
- '&' The value member of a PairType.
- '@' - Expand a macro definition in place. (Not really a runtime component)

The latter '@' sigil is used during compile time. You can think of   it
as an inlined function call. 

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

### Operators

Vish supports a subset of Ruby's operators. Here are the complete list

#### Unary Operators

- ! : Boolean inversion : !true #=> false
- '-' Unary Arithmetic negation : negative numbers: -3, negative expressions
#### Binary infix operators

This list of infix operators is in order of precedence:

- ** : Exponenation
- *, /, % : Multiply and Divide and Modulo
- +, - : Addition and Subtraction
- ==, !==, <, <=, >, >= : Equality and Inequality
- and, or : Logical operators for boolean expressions

## Variables

In Vish, variables are lexically scoped. This is different than dynamically
scoped languages like Perl. In fact, Vish is more like Scheme.

Variables can be assign any valid expression, block or lambda expression.
After assignement, a variable can be dereferenced via the ':var' form.


### Function/Lambda formal parameters

Function parameters act as variables within the body or scope of their execution
context. They can be dereferenced or assigned to like normalvariable.

#### Parameter shadowing

If a parameter shares the name (i.e. symbol) as an outer variable,
it will shadow its outer parent variable. Any assignment, leaving the outer
variable unchanged. This includes the act of binding a value to a parameter
at function call.

#### Lexical Closures

Variables defined in the scope  when a lambda or function is created will be
captured in the lambda binding. Any assignments or dereferences will refer
to the value in the original context/scope. This works like in Scheme or Ruby.

### Local scope of variables

Variables declared within a function or lambda body exist for the life of the
function execution. They disappear after the function exits. 

There are 2 exceptions to this:

1. Variables declared in the outer lexical scope.
2.  Lambdas returned from a function or if the binding() is returned.

#### Lexically scoped variables

Variables declared and set in any outer lexical scope have their bindings exposed
to lambdas  or named functions.

New variables or function parameters are local to the scope of the running
function and disappear after the lambda or function returns.

#### Variables closed within a closure

Variables referenced within a returned lambda  the the lambda persist in the closure.
They persist as long as the lambda persists on the heap.

### The binding

All variables are stored in the current binding. This can be retrieved
via making a call to 'binding()'.
This result can be dereferenced like any variable:

```
# make a new variable
var=123
y=binding()
:y[var:]
# => 123
```

#### Returning the binding from a function and nested functions

Normally, a function declared within a another function can only be used
within that outer function body. It disappears along with all other variables
declared within the outer function body. However, you can always capture the
current binding and return it for future use. An example illustrates this pattern:

```
# nest some function w/o returning anything
defn outer() {
  defn inner() { 9 * 11 }
  inner()
}
outer()
# => 99
# Now capture the binding and return it:
defn outer() {
  defn inner() { 11 * 8 }
  binding()
}
b=outer()
%b[inner:]
88
```

##### Future use of the set! function.

Vish has no let binding syntax or keyword for local variable scoping.
It also has no way to modify those local variables outside of the function
body. In languages like Scheme, you can sometimes do this with the 'set!' procedure.

However, you can just use the vector element assign syntax on the binding object
itself.

Here is a trivial example:

```
# define a function that sets local variable, defines inner function; returns binding
defn mkbaz() { bb=99; defn baz() { :bb }; binding() }
bz=mkbaz()
fb=:bz[baz:]
# => :LambdaType_xxxxxxx
%fb
# =>  99
# now set the bb variable in that binding
bz[bb:]= 100
%fb
# => 100
```

## Collections


Vish has 3 collection types: Vectors or Arrays, List and objects (dictionary or Hash)

### Vectors

Vectors work like Arrays in languages like Ruby.
They be created, indexed and combined into larger Vectors.

```
# a simple vector
l=[0,1,2,3]
:l
# => [0,1,2,3]
:l[2]
# => 2
head(:l)
# => 0
tail(:l)
# => [1,2,3]
l=[:l,[4,5,6]]
l=flatten(:l)
:l
# => [0,1,2,3,4,5,6]

# index via a variable:
idx=4
:l[:idx]
# => 4
# assigment to subscript of vector
v=[0,1,2,3]
v[1]=9
:v
# => [0,9,2,3]
```

Note: the subscript can be any valid expression, when evaluated becomes an index
of the vector.

### Lists

Vish has lists like those in Lisp or Scheme. They can be constructed by combining
pairs with parens:

```
# make a new list:
list=foo: (bar: (baz: 99))
:list
# =>  (foo: (bar: (baz: 99)))
```

### The Null data type

The Null data type can be used to terminate a long list of nested pairs.
This will make the 'list?()' predicate true.

```
# Make a Lisp/Scheme-style list
l=foo: (bar: (baz: Null))
list?(:l)
# => true
#
# Make a chain of pairs without Null
x=foo: (bar: (baz: 2))
list?(:x)
# => false
```

The 'null?()' predicate can be used to check if something is Null.

```
null?(Null)
# => true
null?(2)
# => false
l=foo: (bar: Null)
null?(:l)
# => false
```

### Using the list constructor

You can use the 'list()' constructor to make a proper list with a  terminating Null:

```
# make a Scheme-style list:
l=list(1, 2, 3, 4)
# =>  (1, (2, (3, (4, ()))))
```

#### Deconstructing lists

You can use familiar List/Scheme-like functions like car, cdr, cadr, cddr, .etc to
deconstruct a list

```
l=list(1, 2, 3, 4, 5)
# get first element:
car(:l)
# => 1
>> cdr(:l)
(2, (3, (4, (5, ()))))
>> cadr(:l)
2
>> cddr(:l)
(3, (4, (5, ())))
>> caddr(:l)
3
>> cddr(:l)
(3, (4, (5, ())))
>> car(cdddr(:l))
4
>> car(cdr(cdddr(:l)))
5
```


### Objects

A Object in vish is like a dictionary or Hash/HashMap in other languages.
They are constructed with the '~{ ... }' syntax.

You must use a key value pair to construct them like with JSON syntax

#### Key/Value pairs

A key in a key/value pair is a Vish symbol. An identifier with an immediate trailing colon. E.g. 'id:'
This is followed by any legal Vish expression for the value in the pair.
The expression is first evaluated and then added to the value portion of the pair.

```
pair=foo: 3*9
:pair
# =>  :pairPairType: key: :foo value: 27
typeof(:pair)
# => PairType
```

##### Extracting the key or value from a PairType

You can use either the builtin 'key()' or 'value()'  functions
to extract the individual parts of a Pair.

```
pair=baz: 99
key(:pair)
# => :baz
value(:pair)
# => 99
```

#### Use of the Standard Lib functions for key and value extraction

Vish ships with some functions in its standard library. These are located
in ./std/lib.vs

```
# use of std/lib.vs key/value functions
pair=foo: 44
car(:pair)
# => :foo
cdr(:pair)
# => 44
```

#### Object creation

By combining the '~{ ... }' object method with a list of key/values, 
you can populate the object:

```
obj=~{name: 'James',email:  'james@example.com'}
:obj[email:]
# => 'james@example.com'
```

Objects can also contain lambdas (See Lambdas below) as values. This can
approximate a kind of object-orientation with with state and behaviour
in the same object.

Example:

```
# save behavour in object
user=~{name: ->() {'Sue'},age: 32}
name=%user[name:]
:name
# => 'Sue'
age=:user[age:]
:age
# => 32
```


### Constructors

In Vish, object constructors can be accomplished with functions that return
objects, possibly with lambda values. See functions for a complete description
of function declaration and execution.

However, here is a sample object constructor. The convention is to use upper/camel case
for the function names.

```
# Define a citywith behaviour
defn City(name, state, country) {
  dict(name:,:name,state:,:state,country:,:country,
    pop: ->() { get_pop() },
temp:, ->() { get_temp() })
}
kalamazoo=City('Kalamazoo',Michigan','U.S.A.')
print("Right now in :{:kalamazoo[name:]}, :{:kalamazoo[state:]}, it is :{%kalamazoo[temp:]} for its :{%kalamazoo[pop]} citizens.")
```

###  Builtin object operations

Beside using the above constructs to pull out object members,
you can also perform addition on 2 objects.

```
obj=~{carrier: 'Verizon'}
plan=:carrier + ~{plan: 'Unlimited'}
:plan
#=> {:carrier => 'Verizon', :plan => 'Unlimited'}
```

### Inheritance

In Vish, there is no direct mechanisim to achieve inheritance. But, this can 
be accomplished with the addition above. 

```
defn Base(a, b) { ~{a: :a, b: :b} }
defn Sub(a, b, c) { Base(:a, :b) + ~{c: :c}}
sub=Sub(1, 2, 3)
:sub
```

### Dotted attributes and methods

Vish objects can be referenced via using the dot operator: '.'
This is similar to other languages. Use the ':' or '%' to achieve
access to either the attribute or the lambda to execute.

```
defn Baz(x) {
  ~{x: ->() {:x },
  add1: ->() { :x= :x + 1}
}
baz=Baz(4)
%baz.a
# => 4
%baz.add1
%baz.a
# => 5
```

#### Setter and Getter methods

Objects in Vish must use explicit setters and getters as lambda functions.
As seen above in the prior example,  they can only have effect when executed with the '%' sigil.
The reason for this is because each instance variable is saved in a closure.

Consider this example where we try to use just accesor a dereference  method:

```
defn Getter(x) {
  ~{x: :x,
  set_x: ->(b) { x=:b; :x }
}

g=Getter(1)
:g.x
# => 1
%g.set_x(4)
# => 4
:g.x
# => 1
%g.set_x(5)
# => 5
```

The internal state of the value attached of the key x: is evaluated. It can never
be modified via the set_x: lambda. set_x: will always change the state of the closure's.
They are two distinct objects.

#### The mkattr() Vish Standard Library function

To make this easy, Vish comes with a number of standard library functions.
One of these is 'mkattr()'. This takes a symbol  and a value and returns an 
object. The first parameter, the symbol name also creates a setter method:
'set_key:', where key: is the initial symbol.

E.g.

```
obj=mkattr(foo:, 2)
%obj.foo
# => 1
%obj.set_foo(4)
# => 4
%obj.foo
#  => 4
```

#### Explicit Object attribute assignment

Objects can  assign to their internal attributes via 3 methods:

1. Subscript assignment
2. Use of setter methods (as detailed above)

An example of using subscript assignment

```
o=~{quad: 4, quint: 5}
o[quint:]=44
:o.quint
# => 44
```


Note: You Cannot use the dotted approach to assign values in an object at this time.
This might be changed in the future.
In the mean time, use the subscript approach or supply a setter method.
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
# a simple subtractor
sub=->(i,j) { :i - :j }
# Now call it
%sub(9,3)
# => 6
```

### The return keyword

Although not recommended, a function or lambda can return early from a function via the return keyword:

```
# Returning early from function
defn baz(x) { :x == 10 && return false; :x + 1 }
```

### Passing lambdas to functions

A lambda can be passed as a parameter to any other
function or lambda.

Here is some code that implements the map higher order function from other languages:

```
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

Blocks are delimited by curly braces and contain statements or expressions
delimited by newlines or semicolons. Like in functions or lambdas, the last
statement or expression evaluated is returned as the value of the block overall.

Blocks can be written as one of 3 forms:

- Inline blocks
- Block expressions
- Immediate block as result

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
blk=:{4+3}
# Calling it:
6*%blk
# => 42
```

### Blocks as parameters

```
defn baz(n, blk) { :n + %blk }
baz(4, :{3 ** 2})
# => 13
```

#### Block expressions as lambda closures

Anytime a block is either assigned to a variable or passed as a parameter, it is
promoted to a lambda. You can  think of these kind of blocks as lambda
expressions that take 0 parameters themselves.

Note: As these type of blocks are actually promoted to lambdas, like lambdas,
they close over variables defined in their current context. Thus they are
actually closures themselves.

```
# A block expression as a closure
n=100
b=:{ :n + 10 }
# ... some other code
%b + 1
# => 111
```


#### :  A block can be returned from a function.

To do return a block from a function body as a block expression,
preceeded it with  a clolon ':'.


### Immediate block execution

A block can be immediately executed in place. It is not first promoted into
a lambda first. But it still has the same effect.

```
val=%{5*2/5}
:val
# => 2
# pass to a function:
defn bar(v) { :v * 2 }
bar(%{2})
# => 4
```




## Builtin functions

Vish ships with several builtin functions.
These can be treated like any other user-defined function. They can
be called, used in a pipeline, passed into or out of a function.

### Linked Foreign Function Interface (FFI)

Any FFI function linked via the --require option at runtime, will be
treated like any Vish buit-in function.
