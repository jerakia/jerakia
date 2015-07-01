require 'rubygems'
require 'rubygems/package_task'

spec = Gem::Specification.new do |gem|
    gem.name = "jacaranda"
    gem.version = "0.0.1"
    gem.summary = "Standalone data lookup system"
    gem.email = "craig@craigdunn.org"
    gem.author = "Craig Dunn"
    gem.homepage = "http://github.com/crayfishx/jacaranda"
    gem.description = "Standalone data lookup system"
    gem.require_path = "lib"
    gem.files = FileList["lib/**/*"].to_a
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end
