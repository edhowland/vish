# fixup_returns.rb - method fixup_returns(blocks, BlockReturn) - replaces Return
# node with klass object

def fixup_returns(blocks, klass)
  possible_returns = blocks.map {|n| n.select {|n| n.content.class == Return } }.flatten
  possible_returns.each {|r| r.content = klass.new }
end
