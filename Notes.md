# Notes


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
