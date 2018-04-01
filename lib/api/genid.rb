# genid.rb - method genid(object) - return symbol making up class name and
# object.object_id in hexadecimal
#
#  E.g. genid(1) => :Fixnum_45df3sf353fb9ac - 14 hex digits

def hex_id(object)
  '%012x' % object.object_id
end
def genid(object, klass:object.class)
  "#{klass.name}_#{hex_id(object)}".to_sym
end
