ENV['SPEC_OPTS'] = '--format documentation --color'
require 'rake'

@top_dir=Dir.pwd
ENV['RUBYLIB'] = "#{@top_dir}/lib:#{@top_dir}/jerakia-puppet/lib"
ENV['JERAKIA_CONFIG'] = "#{@top_dir}/test/fixtures/etc/jerakia/jerakia.yaml"

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end


task :default => [:spec]
