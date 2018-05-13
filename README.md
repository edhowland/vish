# Vish : A simple programming language

## Abstract

Vish is a simple general purpose language for expressing  statements for underlying
program API. It derives from  The Viper code editor for screenreader users version 3.x

[Viper](https://github.com/edhowland/viper)


Vish has a simple syntax and a very sparse runtime environment.
However, by requiring Ruby libraries or gems and providing a thin wrapper
to them, it can be turned into any Domain specific Language (DSL) for nearly any
application. It is written in Ruby and hosted in Ruby which provides a rich
ecosystem of tools and libraries.


## Version 0.6.0

Note: Major releases of Vish will drop on April 1st of every year. This is
similar to point releases of Ruby dropping on Christmas day each year.
However, after April 1, 2018 for release 0.5: There will be more frequent
point releases until version 1.0 on April 1, 2019. (Hopefully)

## Features

### Language Environment Features

Vish is a fully compiled language with dynamic interpreter functionality.
It has:

- Compiles to Intermediate Language : (IL).
- Runtime code interpreter for IL code.
- Script runner : Compile and run Vish code (*.vs).
- Interactive Read Eval Print Loop (REPL).
- Syntax Checker in compiler.

#### Additional note regarding the compiler

The Vish compiler can also output a single executable Ruby script that wraps your
compiled Vish bytecode. This makes it easy to deploy your Vish programs
without needing the entire Vish language stack to be present on the target
computer or for other users.

### Language Features

Vish has support for:

- Simple integer expressions
- Boolean expressions
- String expressions, including string interpolations.
- Collections : Vectors (arrays), Dictionaries(Hashes) and Scheme-style lists.
- Lambda or anonymous functions.
- Lexical closures.
- Named functions (supporting recursion).
- Higher order functions. Functions can be passed or returned from other functions. Including both named and lambda functions.
- Optional lazy evaluation
- Foreign Function Interface (FFI) via simple Ruby module code.

## Requirements

Vish requires Ruby 2.2+


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
# fib.vs - fibonacci w/functions
defn fib(n) { 
  :n < 2 && return :n
  fib(:n - 2) + fib(:n - 1)
}
fib(9)
# end of fib.vs
# Now compile it
./bin/vishc -o fib.vsc fib.vs
#
# Now run it
./bin/vsr fibvsc
# => 34
# Now use script runner to compile and run:
./bin/vish fib.vs
# => 34
#
# Now load in interactive REPL
./bin/ivs -l fib.vs
vish> fib(12)
# => 144
[Ctrl-D]
$
```


The file fib.vs can be found in ./compiler/

The convention is to use .vs for source files and .vsc extensions for their
compiled brethren.

## Language Syntax

Vish uses 3 special sigils : ':' and '%' and '~'.

- Colon - ':'  Dereference a variable
- Percent - '%' Execute a block or a block or lambda saved in a variable. Or any named function.
- Tilde '~' Used to create an object/Dictionary

```
var=100
:var
# => 100
#
blk={ true }
%blk
# => true
#
add1=->(x) { :x + 1 }
%add1(4)
# => 5
```

For further reading on the syntax of Vish, please see:
[Syntax](Syntax.md)

## Further reading

To read more information on the Vish language, please see the following files:

- [Overview of language and runtime environment](Overview.md)
- [Vish Language Syntax](Syntax.md)
- [Vish runtime builtin functions](Builtins.md)
- [Changelog of current releases](CHANGELOG.md)
- [LICENSE.txt](LICENSE.txt)
- [Code of conduct](CODE_OF_CONDUCT.md)
- [Contributing to this project](CONTRIBUTING.md)

## License

Vish is licensed under the MIT License. Please see [LICENSE.txt](LICENSE.txt)

## Debugging

If you cannot determine where you went wrong, and need help: Please
enter an issue on the Github issue tracker for the repository.
[Vish issue tracker](https://github.com/edhowland/vish/issues)

## Contributing

Please read the file 
CONTRIBUTING.md

And thank you for helping myself and other blind or visually impaired programmers.
