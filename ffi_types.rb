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

  # _mklambda - Use to create new LambdaType
    def _mklambda(parms, body, id, loc=nil)
    result = LambdaType.new(parms:parms, body:body, _binding:@vm.ctx.vars(), loc:loc)

  end
end