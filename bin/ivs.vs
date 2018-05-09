# ivs.vs - source for Vish code for Vish REPL
argv=getargs()
loop {
  empty?(:argv) && break
  src=fread(head(:argv))
  parse(:src) | _emit() | _icall _call:
  argv=tail(:argv)
}
  loop {
    prints('vish>')
src=read()
    empty?(:src) || { parse(:src) | _emit() | _icall _call: | print() }
  }

