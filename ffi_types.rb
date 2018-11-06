# ffi_types.rb - module FFITypes - methods to create various types using Vish FFI

module FFITypes
  def mkvector(*args)
    args
  end

  def mkpair(key, value)
        PairType.new(key:key, value:value)
  end
  def mkobject(*args)
        ObjectFactory.build(args)
  end
  def _attach(vector)
        result = @vm.bc.codes.length
    @vm.bc.codes += vector
    result
  end
  # _mklambda - Use to create new LambdaType
    def _mklambda(parms, body, id, loc=nil)
    result = LambdaType.new(parms:parms, body:body, _binding:@vm.ctx.vars(), loc:loc)
    result[:arity] = parms.length   #parms.length.zero? ? 0 : parms.length/5
    loc = _attach(result[:body])
    result[:loc] = loc
    result[:id] = id

    result
  end
end