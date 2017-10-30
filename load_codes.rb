# load_codes.rb - method load_codes filename - reads JSON from file, returns
# bc, ctx = ByteCodes, Context. Suitable for input to CodeInterperter

# BUG: This JSON converts symbols into strings. Need to retake them back

require 'json'
require_relative 'vish'
require_relative 'bytecode'
require_relative 'context'



def load_codes io
  blob = io.read
  h = JSON.parse(blob)
  bc = ByteCodes.new
  ctx = Context.new

  bc.codes = h['bc']['codes']
  ctx.constants = h['ctx']['constants']
  ctx.vars = h['ctx']['vars']
  return bc, ctx
end

