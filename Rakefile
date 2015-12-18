require 'rake'
require 'rspec/core/rake_task'

@top_dir=Dir.pwd
ENV['RUBYLIB'] = "#{@top_dir}/lib"
ENV['JERAKIA_CONFIG'] = "#{@top_dir}/test/fixtures/etc/jerakia/jerakia.yaml"

RSpec::Core::RakeTask.new(:spec)

def run_puppet (type, modulename, facts={})
  args = [ 'puppet', 'apply', '--debug' ]
  case type
  when :hiera
    args << '--hiera_config'
    args << "#{@top_dir}/test/int/puppet/hiera.yaml"
  when :databinding
    args << '--data_binding_terminus'
    args << 'jerakia'
  end
  args << [ '--modulepath', "#{@top_dir}/test/int/puppet/modules",'-e', "include #{modulename}" ]

  facts.each { |fact,val| ENV["FACTER_#{fact}"] = val }
  sh(*args.flatten)
  facts.keys.each { |fact| ENV["FACTER_#{fact}"]=nil }
end


task :test_hiera do
  run_puppet(:hiera, "test", { "env" => "dev" })
  run_puppet(:hiera, "test::binding", { "env" => "dev" })
end

task :test_hiera_compat do
  facts={ "jerakia_policy" => "hiera" }
  run_puppet(:hiera, "hiera", facts)
  run_puppet(:hiera, "hiera::subclass", facts)
  run_puppet(:databinding, "hiera", facts)
  run_puppet(:databinding, "hiera::subclass", facts)
end

task :test_data_binding do
  run_puppet(:databinding, "test::binding", { "env" => "dev" })
end

task :test_policy_override do
  facts={ "jerakia_policy" => "dummy" }
  run_puppet(:hiera, "test::dummy", facts)
  run_puppet(:databinding, "test::dummy", facts)
end



task :integration_tests => [:test_hiera, :test_hiera_compat, :test_data_binding, :test_policy_override]
task :default => [:integration_tests, :spec]
