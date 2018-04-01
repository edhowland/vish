# Vish Overview


## Keywords

Vish uses just 7 keywords at the present time:

- break - breaks out of a loop
- return expression - returns out of an executable block with an evaluated expression value
- exit - Exits Vish
- loop { block } - Loops over a block until break encountered, or forever.
- Null - Syntax sugar to create a NullType for Scheme-style lists.
- defn - to create a named function.
- '->(...)' - To create an anonymous function or lambda closure.

## Operators

Vish supplies a subset of Ruby infix and prefix operators.

There is a few differences between Vish operators and those in Ruby.
The difference is between 'and' and &&, and also between 'or' and ||.

The later operators (&&, ||) are statement separators.
The operators 'and' and 'or' are boolean operators in expressions.

Remember, the (&&, ||) operators will shortcircuit the evaluation
of their right-hand expressions if the first left-hand
expression is false for &&, and true for ||.

This semantic is similar to the Unix shell (i.e. Bash).

Also, there is no bit-wise operators.
The '|' symbol is a statement separator, also like in the Unix shell.
(See the section on Pipelines in the Syntax Guide.)

## Defining functions

Vish can also define user functions as well call a few builtin functions.
The keyword to define a function is 'defn functname() { ... }'.
Similar to lambda anonymous functions, but with actual names.

```
# rev.vs - reverses vector
l=[1,2,3,4,5]
defn rev(l) { :l == [] && return :l; rev(tail(:l)) +  [head(:l)] }
rev(:l)
# [5, 4, 3, 2, 1]
```

Alternatively, you can use the builtin 'xmit(object, message)' to get Ruby to
reverse the list for you.

```
# Use builtin Ruby reverse method
l=[1,2,3,4,5]
xmit(:l, reverse:)
# => [5,4,3,2,1]
```

To reverse a Scheme style list, we have to do some more work:

```
# First we need to define the append function:
defn append(x, y) {
  null?(:x) && return :y
cons(car(:x), append(cdr(:x), :y))
}
# now we can define the reverse function using append:
defn rev(l) {
  null?(:l) && return Null
  append(rev(cdr(:l)), list(car(:l)))
}
#
 l=list(1,2,3,4,5)
# => (1, (2, (3, (4, (5, ())))))
 rev(:l)
# => (5, (4, (3, (2, (1, ())))))
```

Note: These above functions exist in ./compiler/append.vs and ./compiler/revlist.vs

### Built-in Functions

There a handful of builtin functions that be invoked
in your Vish scripts. For a complete list, please see:

[Builtins](Builtins.md)

### Custom Ruby functions

You can easily extend Vish to suit your application by defining an interface
to Vish's Builtin dispatch mechanism.

For example, suppose we wanted to reach out to the internet and retrieve a file.
Something like curl:

```
# net_io.rb - interface to Net::HTTP lib: net/http

require 'net/http'

module NetIO
  def self.nread(uri)
    Net::HTTP.get(URI(uri))
  end
end
# Now attach this module to Vish Dispatch 'er
Dispatch << NetIO
# end of net_io.rb
```

Now we can use this in our Vish programs or the ivs REPL shell:

```
$ ./bin/ivs -r ./net_io
vish> nread('https://www.google.com) | fwrite('google.html')
[Ctrl-D]
```

Note: This simple http reader  can be found in ruby_if/net_io.rb

## Pipelines

Vish can chin functions or lambdas together with the '|' (pipe) operator.
The return value of the previous method is passed as the first argument of the
right hand method call.


```
defn foo() { 100 }
defn bar(x) { :x / 2 }
foo() | bar()
# => 50
```

## File operations

Their are several builtin file I/O functions:

- fexist?(filename) - true if filename exists on disk.
- dir?(path) - true if path is a directory
- fread(filename) - returns contents of filename on disk
- fwrite(contents, filename) - Writes out contents to filename on disk.
- frm(path) - removes path if it exists
- pwd() - returns the present working directory

### The pwd lambda:

You can also check the pwd with '%pwd'.
This depends on ./std/lib.vs being loaded, by default, it is.

For instance, you could create a file copy function like this:

```
# define a file copy - fcp
defn fcp(in, out) {
  fexist?(in) || return false
  fread(:in) | frwite(:out)
}
fcp('myfile.old', 'myfile.new')
fexist?('myfile.new')
# => true
```

## The environment

Vish has 2 simple interfaces to the execution environment:

- getenv() - Returns dictionary object of key/value pairs
- getargs() - Returns vector/array of arguments passed to the program.

Note: getargs() includes the name of the Vish script or the REPL - ivs or the
name of the compiled Vish bytecode file in the first element. E.g.:

```
# myfile.vs -
args=getargs()
:args[0]
# => 'myfile.vs'
# end of myfile.vs

# Now run in shell:
$ vish myfile.vs
# => myfile.vs
```

Note: To get more arguments past the last script, pass a dash : '-' between the script
and the first arg to pass to the script.
This only works in the 'vish' executable, since it consumes all scripts names
as source files to compile and run. The '-' stops this consumption.

```
# getallargs.vs - all args
getargs()
# end of getallargs.vs
# Call the above script with additional parameters
$ vish  getallargs.vs - hello world
# =>  ['getallargs.vs', 'hello', 'world']
```

## Using the REPL

Vish comes with a simple REPL (Read/Eval/Print/Loop), for interacting
with the language and trying out expressions.
Located in the ./bin folder, it can be invoked with ./bin/ivs

```
#
$ cd ./bin
$ ./ivs
vish> # this is a comment
nil
vish> 3 + 4
7
vish> val=9*10

vish> :val
90
vish> exit
nil
$
$ # back in your shell.
```

The ivs REPL allows for line editing similar to the pry interactive Ruby shell.
It has  a command buffer history.

Left/right arrows can be used to move the cursor.
Control A/Control E can be used to move to front/end of line.
Up/Down arrows move to previous/next lines int the command buffer history.
Control -C/Control D work as expected.

Any illegal commands will beep the bell.



### The 'read()' builtin function

Read uses the
line editor but does not have any history.


### Caveats with the REPL

Ivs does not allow for forward function references. You can define 2 functions
that refer to each other, but if foo() calls bar(), but 
defines bar() after foo(), and you call foo(),
you will get a UnknownFunction runtime error.

#### The experimental REPL. 

You can try out the experimental REPL in ./bin/repl.rb which does have this problem.
However, it has a bug with entering a '[' character. It will not
be echoed to the screen until after another character has been entered.

Suspect this is a problem in the tty-reader gem or its usage on my part.

## Executables:

Vish ships with several command line programs.
These are all in the ./bin folder.

- vish - Runs all .vs scripts passed to it
- vishc - Compiles .vs files to .vsc runtime files. Can also  check syntax w/ -c
- vsr - Runs compiled .vsc files.
- ivs - Interactive REPL for trying out Vish expressions.

All these programs respond to flags. See the complete list with the --help flag.

### The --no-stdlib flag.

By default, all of these programs will pre-load the file ./std/lib.vs before
compiling and running your program.
This can be disabled with the '--no-stdlib' flag.

## Extending the language with more builtin functions.

All of the executables, except for the compiler,  take the -r, --require file.rb
flag. If you supply a module with singleton functions that any number of
arguments, and return any value, it can be added at runtime.

Then, add it to the Dispatch module at the end of your required file:
This was illustrated in the net_io.rb example above.

