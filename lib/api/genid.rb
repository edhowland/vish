# genid.rb - method genid(object) - return symbol making up class name and
# object.object_id in hex, least significant bits.

def genid(object, klass:object.class)
  "#{klass.name}_#{object.object_id.to_s[-4..-1]}".to_sym
end
