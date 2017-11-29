# Vish : Shell like command language

## Abstrack

Vish is a simple DSL for expressing  statements for underlying
program API. It derives from  The Viper code editor for screenreader users version 2.x.

[Viper](https://github.com/edhowland/viper)

## Version 0.2.0

Example usage:

```
# edit a simple .vsh script

# loop.vsh
add={ :v1 + :v2 }
v1=1; v2=2
acc=0
loop { (:acc ==9) && break; acc=:acc + %add }
:acc
# end of file

# Now compile it
./compiler/vishc.rb loop.{vsh,vshc}

# Now run it
./runtime/vre.rb loop.vshc
# => 9
```
  

The files loop.vsh and loop.vshc can be found in ./compiler/

The convention is to use .vsh for source files and .vshc extensions for their
compiled brethren.
