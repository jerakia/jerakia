require 'rake'
require './lib/jerakia/version'

Gem::Specification.new do |s|
  s.name       = 'jerakia'
  s.version    = Jerakia::VERSION
  s.date       = %x{ /bin/date '+%Y-%m-%d' }
  s.summary    = 'Extendable and flexible ata lookup system'
  s.description = 'Extendable and flexible data lookup system'
  s.authors     = [ 'Craig Dunn' ]
  s.files       = [ 'bin/jerakia', Rake::FileList["lib/**/*"].to_a ].flatten
  s.bindir      = 'bin'
  s.executables << 'jerakia'
  s.homepage    = 'http://jerakia.io'
  s.license     = 'Apache 2.0'
  s.add_dependency 'thor', '~> 0.19'
  s.add_dependency 'deep_merge', '~> 1.0'
  s.add_dependency 'lookup_http', '>=1.0.0'
  s.add_dependency 'sinatra', '< 2.0'
  s.add_dependency 'data_mapper', '~> 1.2'
  s.add_dependency 'dm-sqlite-adapter', '~> 1.2'
  s.add_dependency 'thin', '~> 1.6'

end
