# Bugs

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
