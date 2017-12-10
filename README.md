# Vish : Shell like command language

## Abstrack

Vish is a simple DSL for expressing  statements for underlying
program API. It derives from  The Viper code editor for screenreader users version 2.x.

[Viper](https://github.com/edhowland/viper)

## Version 0.3.0

## Requirements

Vish requires Ruby 2.x.
It has been tested in the following environments:

- Linux : Ruby 2.2
- MacOS - Ruby 2.4
- Windows 10 : Ruby 2.3 (With Fall Creators Update + WSL). In Bash window.

## Installation

Clone this repository:

```
git clone git@github.com:edhowland/vish.git
cd vish
bundle
```

Example usage:

```
# edit a simple .vs script

# loop.vs
add={ :v1 + :v2 }
v1=1; v2=2
acc=0
loop { (:acc ==9) && break; acc=:acc + %add }
:acc
# end of file

# Now compile it
./compiler/vishc.rb loop.{vs,vsc}

# Now run it
./runtime/vre.rb loop.vsc
# => 9
```


The files loop.vs and loop.vsc can be found in ./compiler/

The convention is to use .vs for source files and .vsc extensions for their
compiled brethren.

## Language Syntax

Vish uses 2 special sigils : ':' and '%'.

- : - Dereference a variable
- % - Execute a block or a block saved in a variable.

```
var=100
:var
# => 100

blk={ true }
%blk
# => true
```




## Keywords

Vish uses just 4 keywords at the present time:

- break - breaks out of a loop
- return expression - returns out of an executable block with an evaluated expression value
- exit - Exits Vish
- loop { block } - Loops over a block until break encountered, or forever.

## Operators

Vish uses the same operators as Ruby itself. See the Ruby docs for more information

The difference is between 'and' and &&, and also between 'or' and ||.

The later operators (&&, ||) are statement separators.
The operators 'and' and 'or' are boolean operators in expressions.

Remember, the (&&, ||) operators will shortcircuit the evaluation
of their right-hand expressions if the first left-hand
expression is false for &&, and true for ||.

## Defining functions

Vish can also define user functions as well call a few builtin functions.
The keyword to define a function is 'defn functname() { ... }'.
Similar to lambda anonymous functions, but with actual names.

```
# rev.vs - reverses linked list
l=list(1,2,3,4,5)
defn rev(l) { :l == list() && return :l; list(rev(tail(:l)), head(:l)) }
rev(:l)
# [5, 4, 3, 2, 1]
```

### Builtin Functions

There a handful of builtin functions that be invoked
in your Vish scripts. For a complete list, please see:

[Builtins](Builtins.md)

The above function uses recursion  to reverse a list
## Using the REPL

Vish comes with a simple REPL (Read/Eval/Print/Loop), for interacting
with the language and trying out expressions.
Located in the ./bin folder, it can be invoked with either: ./repl.rb or ./vish.

```
#
$ cd ./bin
$ ./vish
vish> # this is a comment
nil
vish> 3 + 4
7
vish> val=9*10

vish> :val
90
vish> exit
nil
$
$ # back in your shell.
```


### The error log: vish.log

If you encounter a problem when executing the REPL, besides writing to the screen, Vish will
capture the output in ./vish.log in the directory you were in
you invoked vish.
Vish will then exit with a non-zero exit code.
If you cannot determi where you went wrong, and need help: Please
enter an issue on the Github issue tracker for the repository.
[Vish issue tracker](https://github.com/edhowland/vish/issues)

## Contributing

Please read the file 
CONTRIBUTING.md

And thank you for helping myself and other blind or visually impaired programmers.

