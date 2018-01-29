# object.vs - demos the use of object constructors
defn Foo(name, age) {
  mkattr(name:, :name) + mkattr(age:, :age)
}
foo=Foo("Sally", 33)
print(%foo.name)
print(%foo.age)
print("Changing :{%foo.name}'s age")
%foo.set_age(34)
print(%foo.age)
