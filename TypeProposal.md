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





