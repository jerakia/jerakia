require 'rake'
require 'rspec/core/rake_task'

@top_dir=Dir.pwd
ENV['RUBYLIB'] = "#{@top_dir}/lib"
ENV['JERAKIA_CONFIG'] = "#{@top_dir}/test/fixtures/etc/jerakia/jerakia.yaml"

RSpec::Core::RakeTask.new(:spec)

task :hiera_test do
  ENV['FACTER_env'] = 'dev'
  sh('puppet','apply','--debug','--hiera_config',"#{@top_dir}/test/int/puppet/hiera.yaml",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test'
    )
  sh('puppet','apply','--debug','--hiera_config',"#{@top_dir}/test/int/puppet/hiera.yaml",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test::binding'
    )
  ENV['FACTER_env']=nil
end

task :hiera_compat_test do
  ENV['FACTER_jerakia_policy'] = 'hiera'
  sh('puppet','apply','--debug','--hiera_config',"#{@top_dir}/test/int/puppet/hiera.yaml",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include hiera'
    )
  sh('puppet','apply','--debug','--hiera_config',"#{@top_dir}/test/int/puppet/hiera.yaml",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include hiera::subclass'
    )
  sh('puppet','apply','--debug','--data_binding_terminus',"jerakia",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include hiera'
    )
  sh('puppet','apply','--debug','--data_binding_terminus',"jerakia",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include hiera::subclass'
    )
  ENV['FACTER_jerakia_policy'] = nil
end


task :puppet_test do
  ENV['FACTER_env'] = 'dev'
  sh('puppet','apply','--debug','--data_binding_terminus',"jerakia",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test::binding'
    )
  ENV['FACTER_env']=nil
end

task :policy_override_test do
  ENV['FACTER_jerakia_policy'] = 'dummy'
  sh('puppet','apply','--debug','--hiera_config',"#{@top_dir}/test/int/puppet/hiera.yaml",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test::dummy'
    )
  sh('puppet','apply','--debug','--data_binding_terminus',"jerakia",
     '--modulepath',"#{@top_dir}/test/int/puppet/modules",'-e','include test::dummy'
    )
end


task :integration_tests => [:hiera_test, :hiera_compat_test, :puppet_test, :policy_override_test]
task :default => [:integration_tests, :spec]
