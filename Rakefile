# Rakefile for running tests

#import './lib/vish/compile.rake'

desc 'Run Ruby tests'
task :test_rb do
  sh 'ruby test/all_tests.rb'
end

desc 'test_vs - Not implemented'
task :test_vs do
  sh './bin/viper --no-finish -m nop -s test/all_tests.vsh'
end

desc 'test - Run all tests'
task test: [:test_rb]

desc 'default - Runs task test'
task default: [:test]

desc 'builtins_doc : Builds Builtins.md Documentation of internal functions' 
task :builtins_doc do
  dlines = %x{grep '#' ./lib/runtime/builtins.rb}
File.open('Builtins.md', 'w') do |f|
    dlines.lines.each {|l| f.puts "#{l}\n\n" }
  end
end


desc 'yard - Build RubyDoc documentation'
task :yard do
  sh 'yardoc -o ./doc'
end
