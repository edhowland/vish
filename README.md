# Vish : Shell like command language

## Abstrack

Vish is a simple DSL for expressing  statements for underlying
program API. It derives from  The Viper code editor for screenreader users version 2.x.

[Viper](https://github.com/edhowland/viper)


You can enter simple commands with a shell-like syntax:

```
echo hello world | ins :_buf
```

The above compound statement, from the Viper editor, would insert the string
'hello world' in the current buffer at the current cursor position. Note that the variable _buf contains
a reference to the current buffer and it can bedereferenced by using
the ':' sigil before the variable name as in ':_buf'.