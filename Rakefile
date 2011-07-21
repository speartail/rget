require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

require 'rake/clean'
OUTPUT=[ '.yardoc', 'doc', 'gem', 'pkg' ]
CLEAN.include(OUTPUT)
CLOBBER.include(OUTPUT)

task :default => :spec
