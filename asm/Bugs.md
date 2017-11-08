# Bugs for asm/


```
# if bytecodes are [:cls, :pushc, 0, :pushc, 1, ...]
codes:
cls
pushc 0
pushc 1
add
print
halt

# get:  [:cls, :pushc, 0, :pushc, 0, ...]
# The last :pushc, 0 should be :pushc, 1,
```

## Bug: countdown.vasm -> .vshc does not work with vre.rb. problem in ci.execute 


