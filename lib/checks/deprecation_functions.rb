# deprecation_functions.rb - method deprecation_functions
# prints deprecation warnings if any old style Function nodes exist in AST

def deprecation_functions(ast)
  fns = select_class(ast, Function)
  fns.map!(&:content)
  unless fns.empty?
    puts "#{fns.length} Old style function nodes detected"
    puts "These will no longer work in version 0.5.x+.\n You will need to recompile any .vsc files"
    fns.each {|fn| puts fn.name }
  end
  !fns.empty?
end
