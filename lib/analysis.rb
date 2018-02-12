# requires for buffer analysis

require_relative 'analysis/visit_ast'
require_relative 'analysis/memoize_functions'
require_relative 'analysis/convert_assigned_blocks_to_lambdas'
require_relative 'analysis/resolve_logical_or'
require_relative 'analysis/resolve_logical_and'



require_relative 'analysis/match_subtree'
require_relative 'analysis/get_assign_to_blocks'
require_relative 'analysis/extract_lambdas'
require_relative 'analysis/convert_funcall_to_lambda_call'

require_relative 'analysis/extract_functions'
require_relative 'analysis/fixup_returns'
require_relative 'analysis/differentiate_functions'
require_relative 'analysis/resolve_pipecalls'
