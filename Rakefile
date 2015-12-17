require 'rake'
require 'rspec/core/rake_task'

@top_dir=Dir.pwd
ENV['RUBYLIB'] = "#{@top_dir}/lib"

RSpec::Core::RakeTask.new(:spec)

task :hiera_test do
  ENV['FACTER_env'] = 'dev'
  sh('puppet','apply','--debug','--hiera_config',"#{@top_dir}/test/int/puppet/hiera.yaml",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test'
    )
end

task :puppet_test do
  ENV['FACTER_env'] = 'dev'
  ENV['JERAKIA_CONFIG'] = "#{@top_dir}/test/fixtures/etc/jerakia/jerakia.yaml"
  sh('puppet','apply','--debug','--data_binding_terminus',"jerakia",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test::binding'
    )
end

task :policy_override_test do
  ENV['FACTER_jerakia_policy'] = 'dummy'
  sh('puppet','apply','--debug','--hiera_config',"#{@top_dir}/test/int/puppet/hiera.yaml",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test::dummy'
    )
  ENV['JERAKIA_CONFIG'] = "#{@top_dir}/test/fixtures/etc/jerakia/jerakia.yaml"
  sh('puppet','apply','--debug','--data_binding_terminus',"jerakia",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test::dummy'
    )
end


task :default => [:hiera_test, :puppet_test, :spec]
