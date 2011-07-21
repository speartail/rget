require 'rget/cli'
require 'rget/downloader'
require 'rget/errors'
require 'rget/factory'
require 'rget/version'

module RGet
  PROGRAM_NAME = File.basename(__FILE__).gsub(/\.rb$/,'')
end
