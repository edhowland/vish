# test_analysis.rb - tests for

require_relative 'test_helper'

class TestAnalysis < BaseSpike
  include CompileHelper
  include ListProc
# depth of tree. even empty list is depth of 1
  def depth(ast, acc=1)
    if null?(ast)
      acc
    elsif pair?(car(ast))
      v = depth(car(ast), 1 + acc)
      depth(cdr(ast), [acc, v].max)
    else
      depth(cdr(ast), acc)
    end
  end


  def test_can_fold_constant
    assert_eq interpret('3+4'), 7
  end
  def test_depth_of_non_folded_constant_tree_is_5
    compile '4+:a'
    assert_eq 5, depth(@compiler.ast)
  end
  def test_depth_of_simple_constant_expression_is
    compile '1+3'
    assert_eq 3, depth(@compiler.ast)
  end
end
