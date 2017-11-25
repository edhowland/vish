# store_codes.rb - method store_codes(c :Container) - handles dump of container
# of ByteCodes, Context

require_relative 'code_container'

def store_codes(bc, ctx, io)
  container = CodeContainer.new(bc, ctx)
  Marshal.dump(container, io)
  io.close
end
