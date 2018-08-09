defn ex4(opt) {
  defn bad(cc, s) { "bad : " + :s + inspect(:cc)}
  defn spank(cc, s) { "got spanked :" + :s + inspect(:cc) }
  callcc(->(k) {
    print('I am spanker')
    :opt && k(spank(callcc(->(v) {:v}), 'Ouch!'))
    print('about to fail')
  k(bad(callcc(->(v) {:v}), ' juju'))
    print('should not see this')
  })
}

