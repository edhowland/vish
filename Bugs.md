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
## Bug: Very long vish scripts scripts do not work

See compiler/very_long_script.vsh
Run with:

```
cd compiler
./vishc.rb very_long_script.{vsh,vshc}
# Get Parslet failure
```
