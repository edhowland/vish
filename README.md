# Vish : A simple programming language

## Abstract

Vish is a simple general purpose language for expressing  statements for underlying
program API.

Vish has a simple syntax and a very sparse runtime environment.
However, by requiring Ruby libraries or gems and providing a thin wrapper
to them, it can be turned into any Domain specific Language (DSL) for nearly any
application. It is written in Ruby and hosted in Ruby which provides a rich
ecosystem of tools and libraries.


## Version 0.6.3-2

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
- Lambda or anonymous functions. : Lexical closures.
- Named functions (supporting recursion).
- Higher order functions. Functions can be passed or returned from other functions. Including both named and lambda functions.
- Optional lazy evaluation
- Foreign Function Interface (FFI) via simple Ruby module code.
- Curry functions or partial application of functions or lambdas.
- Tail call optimization. Recursive calls written in tail call form do not consume new stack frames.
- Support for Continuation Passing Style: CPS. (As in any language with higher order functions)
- First class (unlimited) continuations

Note: Tail call optimization is, as of version 0.6.2, an experimental feature.
It is turned off by default. Plans are to make it on by default in 0.7+
Experimental version 0.6.4 will rewite the AST to make tail calls work at compile time.

See: [Notes.md](Notes.md)

### Constant folding

Vish, as of 0.6.3-1, folds constants so integer expressions are computed
at compile time, if they contain only constants.

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
# Creates new file fib.vsc containing the bytecode.
# Now run it
./bin/vsr fibvsc
# => 34
# Now use script runner to compile and run:
./bin/vish fib.vs
# => 34
#
# Now load in interactive REPL
./bin/ivs  fib.vs
vish> fib(12)
# => 144
vish> exit
# Now run compiler targeting executable Ruby script
./bin/vishc --ruby -o fib.rb fib.vs
# creates new file fib.rb which is executable
$ ./fib.rb
# => 34
```


The file fib.vs can be found in ./compiler/

### Example usage with tail code optimization

```
# fib-cps.vs - continuation passing style of fib(n)
defn fib(n) {
  defn fib_cps(n, k) {
    zero?(:n) && return k(0, 1)
    :n == 1 && return k(0, 1)
  fib_cps(:n - 1, ->(x, y) { k(:y, :x + :y) })

  }
  fib_cps(:n, ->(x, y) { :x + :y })
}
```

In the above code, we rewrote the Fibonacci function with an internal helper:
'fib_cps' that is written in continuation passing style. This shows internal
functions, use of anonymous lambdas and all recursive calls in tail position.

```
$ cat main.vs
fib(34)


$ TCO=1 ./bin/vish -l ./fib-cps.vs main.vs 
9227465
```


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

- [Installing](INSTALL.md)
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
