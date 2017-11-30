# Notes#  for pry/


## Debugging support

Code to support setting break points in code interpreter are moved to pry/debug.rb

- def debug_handler ctx
- def install_debug_handler ci
-   def ci.continue
-def set_breakpt ci, index
-def  locate_code ci, code


The continue above is installed on the ci instance directly