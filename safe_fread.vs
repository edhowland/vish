# safe_fread.vs - safe version of fread using continuations for exceptions
defn safe_fread(fname) {
  nofile=except('No such file')
    noread=except('Cannot read file')
  result=callcc(->(k) {
    fexist?(:fname) || k(nofile(callcc(->(cc) {:cc})))
    freadable?(:fname) || k(noread(callcc(->(cc) {:cc})))
    fread(:fname)
  })
  :result
}
