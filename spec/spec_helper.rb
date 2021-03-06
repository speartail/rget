$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rget'
#require 'fakefs/spec_helpers'
require 'tempfile'
require 'tmpdir'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

class Tempfile

def self.name(prefix = 'rspec')
  f = Tempfile.new(prefix)
  p = f.path
  f.close!
  FileUtils.remove_entry_secure(p) if File.exists?(p)
  return p
end

end
