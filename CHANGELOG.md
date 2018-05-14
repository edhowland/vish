# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 0.6.0 2018-05-14

This release eliminates the dependence on the rubytree gem.
It implements an S-Expression intermediate abstract syntax tree (AST).

### Additions

- All builtin functions and user supplied FFI Ruby methods are wrapped in lambdas.
  * This allows these to be queried, assigned, passed into and out of functions.
- The REPL - 'ivs' is now an internal REPL implemented in Vish.
- The compiler can output a stand-alone Ruby script executable.
  * This allows deploy compiled programs as  a single executable.
  * In fact, the 'ivs' REPL is implemented this way.

### Deletions

Many source files that are no longer needed.

## 0.5.1 2018-04-07

This is a maintenance release consisting of bug fixes, documentation clean up
and some additional runtime predicate functions.

### Fixes

- Fixed bug where got syntax error sometimes for using symbol as lvalue in expression.

### Additions

- Added many more predicate tests for the Vish language runtime.
- Added some runtime functions such as length, etc.
- List constructor 'cons' is builtin.
- List destructors are in Vish standard library.
- These include: car, cdr, cadr, cddr, etc.
-  list_length is in standard library.

### Changes

- Corrected more documentation and source code to replace List with Vector.
- Cleaned up typeof function to return Vish object types instead of Ruby tclasses.



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

## 0.4.4 - 2018-02-17

### Deprecated

- User defined functions will be changed to lambdas with the name of the function saved in a variable.
- Variables in the output .vsc will no longer be predefined.

The new format of the variables in the Context.vars memeber will become 
a BindingType type. It will act like Ruby's Binding class. You will be able to
get at this type via the binding() call. It acts like a hash, but has Ruby/Scheme local
binding stuff.

When version 0.5.0 ships, you will need to recompile any test code for it to work.
Especially, if you created any functions with 'defn' Also, variables pre-declared in the
.vsc file will no longer work. 

The format of the .vsc (Compile Vish code) will not change, however. 
It might change in a later release.

### Issues

- Formal lambda parameters do not shadow same named variables in outer scope.
- The compiler jump table is not being cleared between compiles.

#### Formal parameter of lambdas

There is a known issue with lambdas with formal parameters having the
same name as a variable in their enclosing scope, where they are created.

E.g.

```
a=10
y=->(a) { :a }
%y(3)
# => 3
:a
# => 3
```

The above example shows where the formal parameter :a does not properly
shadow the :a in the outer scope.

This edge case is fixed in version 0.5.0 and later.


##### Workaround

If this becomes a problem until 0.5.x, you can wrap the lambda in a function:

```
a=10
defn _y(a) {
  ->() { :a }
}
y=:_y(3)
%y
# => 3
:a
# => 10
```

#### Compiler Jumpp Table not being cleared.

There is a small edge case where the internal jump table of the compiler is just
accumulating jump targets between compiler runs. 


Occassionally, a left over jump target for a branch or function call will be overwritten
with the wrong address. This might to wrong behaviour or a infinite loop.

This occasionally occurs in 2 sceanarios:

1. When runing the 'ivs' REPL.
2. When running the unit tests with rake test.

In case #2, just re-run the test suite again.
In the REPL, you will have to exist and re-enter 'ivs'.

This issue is fixed in version 0.5.0

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