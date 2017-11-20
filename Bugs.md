# Bugs

## Bug: broke string interpolation, but fix escape sequences.

```
"head\ndog\n"
head
dog

# But this does not work any more:
"I am :{6*10} years old\n"
# get runtime error
```


## Bug: cannot set variable to itself and expression of another value including itself

```
name="hello "
name=:name + "world"
:name
# Get some undefined thing
```
## Bug: Very long vish scripts scripts do not work

See compiler/very_long_script.vsh
Run with:

```
cd compiler
./vishc.rb very_long_script.{vsh,vshc}
# Get Parslet failure
```
