# startup.rb - method startup - handles all startup chores

# startup - returns string containing all possible code: std/lib/vs, ~/.ivsrc, and .etc
# Can be customized by passing a block returning additional string
def startup(options={}, &blk)
  source = ''
  stdlib_src = stdlib()
  if options[:stdlib] && File.exist?(stdlib_src)
    source += File.read(stdlib_src)
  end
  source += "\n"
  source += yield if block_given?
  source
end
