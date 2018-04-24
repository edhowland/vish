# list_proc.rb - module ListProc - Lisp - like list procedures

module ListProc
  def null?(x)
    x.instance_of?(NullType)
  end
  def undefined?(object)
    Undefined == object
  end
  def atom?(x)
    Builtins.atom?(x)
  end
  def list?(x)
    begin
      Builtins.list?(x)
    rescue => err
  puts "list? error: #{err.message}"
    end
  end
  def pair?(x)
    Builtins.pair?(x)
  end



    def length(sexp, result=0)
    return result if null?(sexp)
    1 + length(cdr(sexp), result)
  end
  def car(x)
    x.key
  end
  def cdr x
    x.value
  end
def cadr(x)
  car(cdr(x))
end
def caadr(x)
  car(cadr(x))
end
  def caddr(x)
    car(cadr(x))
  end
#
end