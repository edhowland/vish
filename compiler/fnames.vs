# fnames.vs - Do the function names end up in ctx.vars?
# compile this file with rake fnames.vsc or : vishc -o fnames.vsc fnames.vs
# Then check the fnames.vsc with:vsr fnames.vsc
# you should get some LambdaType output
#
# does not end up in the ctx vars BindingType tree, but does end up in the heap?
defn foo() {1}
defn bar(a) {:a}
defn baz(b, c) { :b + :c }
y=100
:foo

