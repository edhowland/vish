# Bugs

## Bug: Unknown in test/all_tests.rb: when test_block is enabled

In this case, the total tests just kill the Ruby process with some error status/code of ???
Standalone rt block works, but takes a very long time

## Bug: in vish command line runner with --evaluate

Cannot just pass '-e "expression"' alone, must use a empty null.vs file

```
$ bin/vish -e '100'
# ... just hangs waiting for input

$ touch null.vs
$ ./bin/vish -e '100' null.vs
# => 100
```

## Bug: Cannot escape single quote inside of single quote.

```
'\''
# Syntax error from Parslet
```


### Bug: No arity checking on any type oof lambda

1. First detect arity at compile time
2. For function calls to lambdas, check arity of call

This is a part of larger discussion with regard to variadic methods.
See TODO.md wrt variadiac methods
## Bug: syntax error when trying to return, sometimes

TBD: No sample code yet

Note: Seems to be missing return value. Perhaps this actually a REAL syntax error


## Bug: :fret opcode will not work if encountered inside a loop frame or block frame.

Since the current stack is inside either MainFrame or outer FunctionFrame,
In that case, the frames.peek.ctx wil be nil or undefined method call.

The solution would to 

There should be a compile time semantic check phase
Invoked whenever vish -c, vish or ivs is invoked

### Compile time checks

- Bare return inside loop frame - should be break
- Arity match of known functions
- Empty function/lambda bodies - will output Ruby:nil BAD!!!
- Check for unimplemented keywords: import,export and pragma and new require
- Completely refactor ctx.stack to internal to CodeInterpreter and removed from Context.
- or, search backword in fr.reverse.find {|f| f.kind_of? MainFrame }

The latter is or should be temporary fix to the former solution!


## Bug: Compiler does not check for undefined variables.

```
%blk
blk={ true }
```

In the above example, the block gets after the block is referenced.
Via the variable :blk.

This shoul have a default action at runtime,
or be checked by the compiler during  analysis phase.


## Bug: Should have actual Ruby objects in bytecodes, like 

When written out .vsc files, as marshalled Ruby objects, this is not pure.

Not sure what to do about it, tho.

