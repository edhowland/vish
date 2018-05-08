# vish_path.rb - method: vish_path( ... ) - returns absolute path

def vish_path(subd='')
  expansion = subd.empty? ? '/../..' : "/../../#{subd}"
  File.expand_path(File.dirname(__FILE__) + expansion)
end