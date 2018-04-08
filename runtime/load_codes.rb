# load_codes.rb - method load_codes filename - reads JSON from file, returns
# bc, ctx = ByteCodes, Context. Suitable for input to CodeInterpreter


#require_relative '../lib/vish'
##require_relative '../bytecode'
##require_relative '../context'
require_relative "code_container"



def load_codes io
  blob = io.read
  container = Marshal.load(blob)
  bc = container.bc
  ctx = container.ctx
  return bc, ctx
end

