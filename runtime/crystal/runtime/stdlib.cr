# stdlib.rb - returns expanded path to internal ./std/lib.vs

def stdlib
  File.expand_path(File.dirname(__FILE__) + '/../../std/lib.vs')
end