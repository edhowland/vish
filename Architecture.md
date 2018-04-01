# Architecture

## Abstract

Need to change implementation of compiler into something that uses Vish data types. 
Specifically, use of the PairType aka: a Scheme cons cell type
for the implementation of the AST nodes. This is a big change but allows for
the ability to quote things and then work with them in Vish directly.

### Quoting expressions

A quoted expression in Vish is like it is in Scheme, a compiled thing, but not evaluated one.

E.g.:

```
(define x (quote (+ 1 2)))
x
# => '(+ 1 2)
(eval x)
# => 3
```

The quoted thing is parsed, but not evaluated like with similar constructs. It
can be manipulated, then evaluated later.

We could propose the same similar construct in Vish:

```
# define a quoted expression:
expr=<1 + :a>
# => ExpressionType (w/ distinct  ID code
a=5
eval(:expr)
# => 6
car(:expr)
# => :+
cadr(:expr)
# => 1 or :number
```



