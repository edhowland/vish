# Bugs


## Bug: The following should work, but gets type conversion error

```
4*4 == 16
Cannot convert false into int. ???

# But this works:
16 == 4*4
# So the order is important
```

This most likely arises because  
the order of the emitted bytecodes is:
```
codes:
cls
pushc 0
pushc 1
pushc 2
eq
mult
cls
nop
print
halt
```

You can see the :eq occurs before the :mult
