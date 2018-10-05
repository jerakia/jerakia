$LOAD_PATH.unshift(File.join([File.dirname(__FILE__), '..', 'lib']))

JERAKIA_ROOT = File.expand_path('..', File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'mocha'
require 'jerakia'
require 'webmock/rspec'

RSpec.configure do |c|
  c.mock_with :mocha
  c.pattern = '**/*_spec.rb'
end


WebMock.disable_net_connect!(allow_localhost: true)
