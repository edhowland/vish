# Bugs

## Bug: Compiler does not check for undefined variables.

```
%blk
blk={ true }
```

In the above example, the block gets after the block is referenced.
Via the variable :blk.

This shoul have a default action at runtime,
or be checked by the compiler during  analysis phase.


## BUG: Massively misspelled interpreter

Should be 

interpreter - Good
interperter - Bad

## Bug: Should have actual Ruby objects in bytecodes, like LoopFrame objects

When written out .vshc files, as marshalled Ruby objects, this is not pure.

Not sure what to do about it, tho.

## Bug break within block but called within loop construct gets opcode error

```
bk={ break }
loop { %bk }
# output in vish.log:

```


## Bug: Very long vish scripts scripts do not work

See compiler/very_long_script.vsh
Run with:

```
cd compiler
./vishc.rb very_long_script.{vsh,vshc}
# Get Parslet failure
```
