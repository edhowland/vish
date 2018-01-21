# user.vs - test OOP stuff
defn User(first, last, age) {
  this=dict(first:, :first, last:, :last, age:, :age)
  ax(:this,full:,->() { :this[first:] + ' ' + :this[last:] })
  :this
}
ed=User('Ed', 'Howland', 60)
%ed[full:]

