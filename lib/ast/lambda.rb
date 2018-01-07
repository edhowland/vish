# lambda.rb - class Lambda < NonTerminal
class Lambda < NonTerminal
  def initialize arglist=[]
    @arglist = arglist
#    @closures = []
  end
  attr_reader :arglist
#  attr_accessor :closures
  
  # subtree - constructs a subtree of nodes: LambdaEntry, Block, LambdaExit
  # Parameters:
  # arglist - Array - list of (string literals)? - passed to LambdaEntry
  # body - Block of AST nodes making up body of function
  def self.subtree(arglist, body)
    arglist.reject!(&:nil?)
    argsyms = arglist.map {|a| a.value.to_sym }
    this = self.new(arglist)
    top = mknode(this)
    top << mknode(LambdaEntry.new(arglist))
    # locate unbound derefs
    _body = node_unless(body)
#    vars = select_class(_body, Deref)
#    vars.reject! {|v| argsyms.member? v.content.value.to_sym }
    # TODO: MUST: find any locals instantiated herein. Not just parameters
    # Locate any assignments
#    assigns = select_class(body, Assign)
#    assigns.map!(&:first_child)
#    assigns.map! {|a| a.content.value.to_sym }
#    vars.reject! {|v| assigns.member?(v.content.value.to_sym) }
    # create tuples of the StoreClosure and original Deref
#    closures = vars.map {|v| scl = StoreClosure.new(Closure.create_id); scl.value = v.content.value.to_sym; [v, scl] }
#    closures.each {|v,scl| v.content = DerefClosure.new(scl.closure_id) }
#    this.closures = closures.map {|v, scl| scl }


    top <<  _body
    top << mknode(LambdaExit.new)

    top
  end

  def emit(bc, ctx)
    # nop
  end

  def inspect
    "#{self.class.name}: arglist: #{@arglist.map(&:inspect)}"
  end
end
