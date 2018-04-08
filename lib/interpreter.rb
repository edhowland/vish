# requires for interpreter/
# Nust make all these string double-quoted strings for Crystal language support

require_relative "../common/code_container"
require_relative "interpreter/register"

require_relative "interpreter/default_handler"
require_relative "interpreter/interrupt_called"
require_relative "interpreter/opcodes"
require_relative "interpreter/interpreter_methods"
require_relative "interpreter/code_interpreter"

