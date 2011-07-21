# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rget/version"

Gem::Specification.new do |s|
  s.name        = "rget"
  s.version     = RGet::VERSION
  s.authors     = ["Peter Hoeg"]
  s.email       = ["p.hoeg@northwind.sg"]
  s.homepage    = ""
  s.summary     = %q{Platform agnostic CLI interface to various downloaders}
  s.description = %q{rget provides a CLI interface to axel, curl, wget and fallback to plain ruby}

  s.rubyforge_project = "rget"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('fakefs', '>=0')
  s.add_development_dependency('rdiscount', '>=0')
  s.add_development_dependency('rspec', '>=0')
  s.add_development_dependency('yard', '>=0')
end
