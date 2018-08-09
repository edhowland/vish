defn ex4() {
  defn bad(s) { :s }
  defn spank(s) { :s }
  callcc(->(k) {
    print('about to fail')
  k(bad('bad juju'))
    print('should not see this')
  })
}

