# Bugs

## Bug: Cannot parse the following:

```
name=14
:name - 33
# get parse error

4 + :name
# this works
```

## Bug: asm/vasm.rb cannot deal with pathnames containing /'s in pathname for comment node
