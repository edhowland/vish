# Rakefile for running tests

#import './lib/vish/compile.rake'

task :test_rb do
  sh 'ruby test/all_tests.rb'
end

task :test_vsh do
  sh './bin/viper --no-finish -m nop -s test/all_tests.vsh'
end

task test: [:test_rb]

task default: [:test]

task :builtins_doc do
  dlines = %x{grep '#' ./lib/runtime/builtins.rb}
File.open('Builtins.md', 'w') do |f|
    dlines.lines.each {|l| f.puts "#{l}\n\n" }
  end
end


task :yard do
  sh 'yardoc -o ./doc'
end
