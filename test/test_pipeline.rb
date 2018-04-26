# test_pipeline.rb - tests for pipe constructs.
# E.g. echo('hello world') | cat() | print()'

require_relative 'test_helper'

class TestPipeline < BaseSpike
  include CompileHelper
  def test_builtins_can_be_chained
    interpret 'echo("Hello world") | cat() | print()'
  end
  def test_functions_can_be_chained
    result = interpret 'defn rx(x) { "---%{:x}>>>" };defn tx(x) { :x * 2 };tx(4) | rx()'
    assert_eq result, '---8>>>'
  end
  # long chains are ok
  def test_can_do_really_long_chains
    result = interpret '55 | dup() | dup() | dup() | dup()'
    assert_eq result, 55
  end
end
