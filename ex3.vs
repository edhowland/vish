defn ex3() {
  ex1=:{"exception #1"}
  ex2=:{"Exception 2"}
  callcc(->(k) {
    {
      print('before ex1')
k(%ex1)
print('after ex1')
    }; k(99)
  })
}
