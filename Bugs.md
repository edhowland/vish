# Bugs

## Caveat: avoid the following. Need parenthesis around expressions in grammar

```
# works:
16 == 4*4

# does not work because of left associated binding
4*4 == 16
# get a type error
```

Although the above works in Ruby, we need to do the following:

```
(4*4) == 16
```

