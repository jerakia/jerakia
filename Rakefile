require 'rake'
require 'rspec/core/rake_task'

@top_dir=Dir.pwd

RSpec::Core::RakeTask.new(:spec)

task :puppet_test do
  ENV['FACTER_env'] = 'dev'
  sh('puppet','apply','--debug','--hiera_config',"#{@top_dir}/test/int/puppet/hiera.yaml",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test'
    )
end

task :default => [:puppet_test, :spec]
