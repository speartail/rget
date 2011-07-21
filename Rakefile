require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

# rake clean up
require 'rake/clean'
OUTPUT=[ '.yardoc', 'doc', 'gem', 'pkg' ]
CLEAN.include(OUTPUT)
CLOBBER.include(OUTPUT)

# YARD
require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files   = [ 'lib/**/*.rb' ]
  t.options = [ '' ]
end

desc 'Run default documentation tool'
task :doc => :yard

task :default => :spec
