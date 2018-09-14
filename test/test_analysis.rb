# test_analysis.rb - tests forconstant folding, tail code optimizations, others

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
  def test_modulus_is_constant_folded
    compile '15 % 3'
    assert_eq 3, depth(@compiler.ast)
  end
  # multiple sub-expressions wherein all the exprs are constant
  def test_multiple_sub_expressions
    secs_in_year = compile '60*60*24*7*52'
    assert_eq 3, depth(@compiler.ast)
  end
  def test_multiple_all_varibles
    all = compile ':a +:b - :c * :d / :e'
    assert_eq 11, depth(@compiler.ast)
  end
  def test_mix_of_variables_and_constant_exprs
    compile ':a + :b + 5 + 8 * 10'
    assert_eq 7, depth(@compiler.ast)
  end
end
