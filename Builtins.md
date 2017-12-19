  def self.echo(*args)

```
echo('hello', 'world')
# => "hello world\n"
```


  def self.throw(*args)

Throws VishRuntimeError with message or default message.

  def self.read(*args)

Reads a string from input: chomps the possible trailing newline.

```
name=read(); print("Hello :{:name}\n")
```

  def self.readi(*args)

Reads an integer from stdin.

```
i=readi();:i * 4
# enters: 4
# => 16
```

  def self.list(*args)

Creates a list (Ruby array) from its number of arguments

```
x = list(1,2,3); :x != list() && print('false')
# => 'false'
```

  def self.head(*args)

Returns the head element of the list.

```
li=list(1,2,3,4)
head(:li)
# => 1
```

  def self.tail(*args)

Returns the tail of a list:

```
li=list(0,1,2,3,4)
tail(:li)
# => [1,2,3,4]
```

  def self.print(*args)

Prints all of its output to stdout

```
print(1,2,3)
# => 1
# 2
# 3
```

def self.dict(*args)

Creates a dictionary object from key value pairs (E.g. Hash)


```
dict('a',1,'b',2,'c',3)
# => {'a' => 1, 'b' => 2, 'c' => 3}
```

def self.ix(arr,ix)

Indexes its first arg with its second arg. Will work with list or dict

```
arr=list(1,2,3,4)
:arr | ix(1)
# => 2
```


