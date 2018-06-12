# test_function.rb - tests for Function

require_relative 'test_helper'

class TestFunction < BaseSpike
  include CompileHelper
  def test_actually_calls_function
    result = interpret 'defn foo() {true};foo()'
    assert result
  end
  def test_recursive_call_with_parameter
    result = interpret 'defn foo(x) { :x == 0 && return 0; foo(:x - 1) };foo(10)'
    assert_eq result, 0
  end
  def test_loop_raises_compile_error_when_break_from_within_lambda_within_function
    assert_raises CompileError do
      interpret 'defn foo(fn) { %fn() }; loop { foo(->() { break }) }'
    end
  end
  def test_function_can_return_lambda
    result = interpret 'defn foo() { ->() {1} }'
  end
  def test_function_returns_lambda_which_be_called
    result = interpret 'defn bar() { ->() {99} };fn=bar();%fn()'
    assert_eq result, 99
  end
  def test_lambda_can_call_user_function
    result = interpret 'defn baz() { true };fn=->() { baz() };%fn()'
    assert result
  end

  # Functions are also lambdas
  def test_can_call_function_as_if_it_was_lambda
    result = interpret 'defn fu() {0}; %fu'
    assert_eq result, 0
  end

  # test for variable scoping
  def test_functions_have_local_scope_for_local_variables
    result = interpret 'defn foo() { c=12};foo();:c'
    assert_eq result, Undefined
  end
  def test_outer_variable_survies_after_function_declaration
    result = interpret 'a=9;defn foo(a) { a=22};:a'
    assert_eq result, 9
  end
  def test_shadowed_variables_retain_their_value_after_function_call_w_same_named_parameter
    result = interpret 'z=10;defn baz(z) {:z};baz(99);:z'
    assert_eq result, 10
  end

  # torture tests

def fx(&blk)
l=('a'..'j').to_a
u=l.map(&:upcase)
n=(1..10).to_a

z=l.zip(n)
x = u.zip(n)

z.each do |c, i|
  x.each do |d,  j|
    yield(c+d, i*j)
  end
end

end


def rdefs
  r = []
  fx {|a,n| r << "def #{a}(); #{n}; end" }
  r.join("\n")
end
def rcalls
  r = []
  fx {|a, n| r << "#{a}()" }
  r.join(" + ")
end

def ruby_code
  rdefs + "\n" + rcalls
end

# vish stuff
def vdefs
  r = []
  fx {|a,n| r << "defn #{a}() { #{n} }" }
  r.join("\n")
end

def vish_code
  vdefs + "\n" + rcalls
end


  def test_torture_fn_defs_n_calls
    assert_eq eval(ruby_code), interpret(vish_code)
  end
end
