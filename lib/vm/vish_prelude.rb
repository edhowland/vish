# vish_prelude.rb - class VishPrelude - Singleton to create InternalFunctions

class VishPrelude
  class << self
    def for_all_methods(ffi, &blk)
      (ffi.methods - Object.new.methods).each(&blk)
    end

    # Get all builtin modules
    def vish_builtins
      [FFITypes, VishPredicates]
    end

    def build(vm)
      vish_builtins.each {|m| vm.ffi.extend m }
      for_all_methods(vm.ffi) do |ffi|
        vm.ctx.vars[ffi] = InternalFunction.new(parms:[], body:[:pushl, ffi, :icall], _binding:vm.ctx.vars, loc:vm.bc.codes.length)
        vm.ctx.vars[ffi][:name] = ffi
        vm.ctx.vars[ffi][:arity] = -1
      vm.bc.codes += vm.ctx.vars[ffi][:body]
      end
    end
  end
end