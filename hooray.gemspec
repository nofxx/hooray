lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'hooray/version'

Gem::Specification.new do |s|
  s.name        = 'hooray'
  s.version     = Hooray::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors     = ['Marcos Piccinini']
  s.homepage    = 'http://github.com/nofxx/hooray'
  s.email       = 'x@nofxx.com'
  s.description = 'Find all those devices connected in LAN'
  s.summary     = 'Find devices connected in LAN'
  s.license     = 'MIT'

  s.executables = ['hoo']
  s.default_executable = 'hoo'

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'thor'
  s.add_dependency 'paint'
  s.add_dependency 'macaddr'
  s.add_dependency 'net-ping'
  s.add_dependency 'table_print'
end
