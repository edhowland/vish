# Bugs

## Bug: passing block to function does not seem to work.

In the case of a inline block. E.g.:

```
# this does not work correctly
defn foo(fn) { :fn }
foo({4*3})
# => 12
# Should be: :LambdaType_xxxxx
#
# gets worse:
defn bar(x) { %x }
bar({2})
# G

et Ruby syntx error
 opcodes': Lambda not found: unknown (LambdaNotFound)
  from /home/vagrant/src/vish/lib/interpreter/code_interpreter.rb:76:in `c
```

This is caused by the previous bug where the block: {1} is evaluated before being passed to
the bar(x) and x is bound to the result: 1.
Then %x tries to find the lambda for that.

This should happen at the compiler / AST level.
## Possible Bug: reading stdin input does not work in compiled mode

But does work in interactive mode.


## Possible Bug: infix_oper not promoted enough in Vish grammar

```
# check this
1 + { 2 }
```


## Bug: Try to call a lambda witha block call

```
lm=->() { true }
%lm
# Should have been %lm()
# get no method error
```


## Bug: Call a block with lambda call

Get no error, but nil is returned

```
bk={1}
%bk()
# => nil
```

## Bug: :fret opcode will not work if encountered inside a loop frame or block frame.

Since the current stack is inside either MainFrame or outer FunctionFrame,
:frep trys to push the return value. It might be returning to a LoopFrame or BlockFrame.
In that case, the frames.peek.ctx wil be nil or undefined method call.

The solution would to 

- Completely refactor ctx.stack to internal to CodeInterpreter and removed from Context.
- or, search backword in fr.reverse.find {|f| f.kind_of? MainFrame }

The latter is or should be temporary fix to the former solution!




## Bug: Compiler does not check for undefined variables.

```
%blk
blk={ true }
```

In the above example, the block gets after the block is referenced.
Via the variable :blk.

This shoul have a default action at runtime,
or be checked by the compiler during  analysis phase.


## Bug: Should have actual Ruby objects in bytecodes, like LoopFrame objects

When written out .vshc files, as marshalled Ruby objects, this is not pure.

Not sure what to do about it, tho.

## Bug break within block but called within loop construct gets opcode error

```
bk={ break }
loop { %bk }
# output in vish.log:

```


## Bug: Very long vish scripts scripts do not work

See compiler/very_long_script.vsh
Run with:

```
cd compiler
./vishc.rb very_long_script.{vsh,vshc}
# Get Parslet failure
```
