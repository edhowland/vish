# test_pipeline.rb - tests for pipe constructs.
# E.g. echo('hello world') | cat() | print()'

require_relative 'test_helper'

class TestPipeline < BaseSpike
  include CompileHelper
  def test_builtins_can_be_chained
    interpertit 'echo("Hello world") | cat() | print()'
  end
  def test_functions_can_be_chained
    result = interpertit 'defn rx(x) { "---:{:x}>>>" };defn tx(x) { :x * 2 };tx(4) | rx()'
    assert_eq result, '---8>>>'
  end
end
