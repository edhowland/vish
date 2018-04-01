
# Module Proposal

## Abstract

As of Vish 0.5.0,  named functions are just syntax sugar for
assigning  a lambda to a variable of the same name as the function.
This introduces the problem of name collision when considering creating library code
that should not pollute the client code that links to it.

## The 'import' keyword.

Vish has had the 'import "string"' keyword since the 0.4.x vintage.
Although, as of 0.5.x it currently does nothing.

## The 'export' keyword.

As of Vish 0.5.0, there exists the 'export' keyword.

```
# In file: foo.vs:
export foo, bar, baz

defn foo() {}
defn bar() {}
defn baz() {}
defn count(a) {}

# In client.vs:
import "foo"

y=foo()
x=count(1)
# Runtime error, no matching function name for count
```
