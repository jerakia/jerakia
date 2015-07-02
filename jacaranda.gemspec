require 'rake'

Gem::Specification.new do |s|
  s.name       = 'jacaranda'
  s.version    = '0.0.1'
  s.date       = '2015-06-01'
  s.summary    = 'Develop'
  s.description = 'Develop'
  s.authors     = [ 'Craig Dunn' ]
  s.files       = [ 'bin/jacaranda', Rake::FileList["lib/**/*"].to_a ].flatten
  s.homepage    = 'http://github.com'
  s.license     = 'Apache 2.0'
end
