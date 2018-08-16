# safe_fread.vs - safe version of fread using continuations for exceptions
defn safe_fread(fname) {
  callcc(->(k) {
    fexist?(:fname) || k("no such file %{:fname}")
    freadable?(:fname) || k("Cannot read from %{:fname}")
    fread(:fname)
  })
}
