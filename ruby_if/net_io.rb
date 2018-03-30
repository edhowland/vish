# net_io.rb - interface to Net::HTTP lib: net/http

require 'net/http'

module NetIO
  def self.nread(uri)
    Net::HTTP.get(URI(uri))
  end
end
# Now attach this module to Vish Dispatch 'er
Dispatch << NetIO
