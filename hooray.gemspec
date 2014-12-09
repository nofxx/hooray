lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'hooray/version'

Gem::Specification.new do |s|
  s.name        = 'hooray'
  s.version     = Hooray::VERSION

  s.authors     = ['Marcos Piccinini']
  s.description = 'Find all those devices connected in LAN'
  s.homepage    = 'http://github.com/nofxx/hooray'
  s.summary     = 'Find devices connected in LAN'
  s.email       = 'x@nofxx.com'
  s.license     = 'MIT'

  s.files = Dir.glob('{lib,spec}/**/*') + %w(README.md Rakefile)
  s.require_path = 'lib'

  s.add_dependency 'thor'
  s.add_dependency 'paint'
  s.add_dependency 'macaddr'
  s.add_dependency 'net-ping'
  s.add_dependency 'table_print'
end
