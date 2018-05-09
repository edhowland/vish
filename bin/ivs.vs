# ivs.vs - source for Vish code for Vish REPL
  loop {
    prints('vish>')
src=read()
    empty?(:src) || { parse(:src) | _emit() | _icall _call: | print() }
  }

