# Bugs

## Bug: Probably not executing the final tests in test/test_compile.rb

Are they outside of the class definition?


## Bug: saved blocks are not retained past one time thru loop in bin/repl.rb

Just saving the Context as we pass thru through the loop is not enough.
The next evaluation overwrites the entire bc.codes array.
The blocks are stored at the end of this array after the :halt instruction.

What needs to happen is 
the blocks from the VishCompiler object need to be saved from each pass.
The analyze phase must be allowed to take in additional blocks from earlierpasses.
Eventually we build up a range of blocks to append in the generate phase.

However, BlockEntry.emit method MUST not use another
location from wither this pass or some previous one.

This is really hard CS!

## Bug: cannot set variable to itself and expression of another value including itself

NOTE: This only happens in ./bin/repl.rb
```
name="hello "
name=:name + "world"
:name
# Get some undefined thing
undefinedworld
# But this works
name='hello '
var=:name + 'world'
:var
hello world
```

The problem is related to the bug about not being able to refer to non-existant blocks every time through the loop.



## Bug: Very long vish scripts scripts do not work

See compiler/very_long_script.vsh
Run with:

```
cd compiler
./vishc.rb very_long_script.{vsh,vshc}
# Get Parslet failure
```
