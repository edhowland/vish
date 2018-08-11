# mkpez.vs - Vish mkpez generator

defn mkpez() {
  ival=0
  gen= 0

->() {
    zero?(:gen) || return %gen
    callcc(->(ret) {
      loop {
              callcc(->(next_pass) {
          gen=:next_pass
          ret(:ival)
        })
        ival=:ival + 1
      }
      # out of loop
    })
  }
  # out of lambda
}
