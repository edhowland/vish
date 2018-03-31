# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 0.5.0 - 2018-04-01

- Changed variable storage to use BindingType, ala: Scheme
- Promoted  Scheme-style lists to first class citizens
- Added Null syntax sugar to represent NullType subclass of PairType for above.
- Added missing feature to allow assignment of value of subscripted vector or object.
- Documentation changed to name arrays as vectors and lists as lists. (Scheme-style)

### Deprecations

The use of the 'list(...)'  builtin is used to create chains of cons pairs
with a terminal Null. Formerly, it as used to create a flattened
vector or array.

You can accomplish via just creatinga vector, then use the 'flatten(:vector)' builtin
if needed.


## 0.4.3 - 2018-02-09

-  Updated this file: CHANGELOG.md) to format of keepachangelog.com. (See link above)
- Corrected spelling mistakes in test/test_*.rb

## [0.4.2] - 2018-02-08

- Corrected argument passing failures on derefed lambda calls from a list index.

```
%p[0] .. %p[foo:]() .. %p[%lm(2)](1) .. %p[0](1,2,3)

# Also:
%p.foo .. %p.foo() .. %p.foo(1) .. %p.foo(1,2)
```

- Also refactored the latter type of lambda calls to be just syntax sugar for the [] version.

## 0.4.1 - 2018-02-04

- Corrected problem with passing output of method_call to pipe/and/or expressions
- Added ability to append additional dispatchable modules to runtime, via the -r
- require flag.. See README.md for details
- Added -l, --load file.vs flag to compiler/ivs/vish runtime to preload files/lib
- Added --no-stdlib for ivs/vishc/vish programs to prevent preloading ./std/lib.vs.
- This file has the 'mkattr(sym:, value)' function.
Used in object constructor functions.
- Adds :%var.symbol, and %var.set_symbol(value) methods.

## 0.4.0 - 2018-01-15

### Breaking changes

- Breaking change: runtime/vre.rb changed to runtime/vsr.rb
- Breaking change: compiler/vishc.rb must have -o outputfile to
  actually perform the file.
  This is represented in compile/Rakefile for rule. Now uses the internal
  compile and compose methods.

- Possible Breaking change: Block expressions are promoted to lambdas.
This should not affect any running change. Only an internal 
change in representaion in the runtime/compiler


Can create objects and lists with the new syntax. See Syntax.md for details.
Note: Can use the var.attr syntax to access
elements in a dictionary/object.
These can also act as method calls, if the used with the '%' sigil.

- There is a new type: The PairType. This represents any pair but can be used
to create a key/value pair in the JSON-like syntax:

```
pair=foo: 100
typeof(:pair)
# => PairType
```

You can get the individual members of the PairType with the key()/value() functions

```
key(:pair)
# =>  :foo
value(:pair)
# => 100
```

These pairs can be used to create objects by combining them with the object
syntax.

```
obj=~{foo: 1, bar: 2, baz: 3}
:obj.foo
# => 1
:obj.bar
# => 2
:obj.baz
# => 3
```

You can also use the [key] syntax as well

```
obj[foo]
# => 1
#... .etc
```

- Can use these file I/O routines:
1. fexist?(filename)
2. fread(filename)
3. fwrite(filename)
4. frm(filename) - removes file

##  0.3.0 - 2017-12-17

No available information at this time.


## 0.2.0 - 2017-11-30

- Added:
Executable blocks. Can be saved in variables and run again with '%' sigil.
E.g. 

```
bk={ 1 + 2}
%bk
```
- Added loops.
E.g.

```
val=0; loop { val=:val + 1; (:val == 10) && break }; :val
# => 10
```

- Added keywords break, exit and return [ ... expression]
Exit invokes the exit interrupt handler. Which justcauses the :exit opcode to run.
Like the :halt opcode, but uses a descendent class ExitState.
This can be queried with CodeInterperter.last_exception

- Git tags:
- Turing.complete


## 0.1.0 - 2017-11-13

- AST:

- Implemented actual Abstract Syntax Tree using rubytree gem.
Cleaned up interp.rb to code_interperter.rb
- Added debug support in pry_helper.rb. go method returns CodeInterperter.
  for_broke(ci) will run the entire thing. E.g. for_broke(go)
-   one: method to run one fetch, decode and execute step.
  what_is: given code from fetch, prints Human  readable value.


- working.example:

First attempt. 
Using interp.rb to pull the bytecodes and then run them given ByteCodes, Context.
Main code in main.rb: Loads source, compiles and runs it in interp method.
The parse method just returns 1 dimensional array of bytecodes.
The opcodes method returns hash of bytecode to lambdas that
  take ByteCodes, Context and manipulate the stack in  Context.stack.

## Pre-history

Checkout git log for many breaking changes and notes  about code flux.