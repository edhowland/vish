# all_tests.rb - requires for test classes

require_relative 'test_helper'

require_relative 'test_bytecodes'
require_relative 'test_context'
require_relative 'test_frame'
require_relative 'test_code_interpreter'
require_relative 'test_string'

require_relative 'test_compile'
require_relative 'test_icall'
unless ENV['NOBLOCK']== '1'
  require_relative 'test_block'
end
require_relative 'test_branch'
require_relative 'test_variables'
require_relative 'test_parser'
require_relative 'test_locked_stack'

require_relative 'test_loop'
require_relative 'test_lambda'
require_relative 'test_builtins'
require_relative 'test_pipeline'

require_relative 'test_function'
require_relative 'test_closure'

require_relative 'test_vector'
require_relative 'test_list'

require_relative 'test_symbol'

require_relative 'test_object'
require_relative 'test_pair_type'
require_relative 'test_binding_type'
require_relative 'test_expressions'
require_relative 'test_vish'
require_relative 'test_curry'
require_relative 'test_continuations'




