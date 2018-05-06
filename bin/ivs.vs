# ivs.vs - source for Vish code for Vish REPL
  loop {
    prints('vish>')
    read() | parse() | _emit() | _icall _call: | print()
  }
