# Bugs

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

### Hint: Undefined is assigned before code is run

Perhaps, the code to perform the assignment is not working?
And the previous value happens?
I think this is a semantic problem, in the case when :name is performed in:
name=:name, The compiler does not that it was previous set.
## Bug: Very long vish scripts scripts do not work

See compiler/very_long_script.vsh
Run with:

```
cd compiler
./vishc.rb very_long_script.{vsh,vshc}
# Get Parslet failure
```
