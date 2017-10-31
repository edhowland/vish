# utilities.rb - methods: mkconstants, ...

require_relative '../context'


def mkcontext ctx
  c = Context.new
  c.constants = ctx[:constants][:clist]
  c
end

def mkconstants(clist)
  clist
end

def mkint value
  value.to_i
end