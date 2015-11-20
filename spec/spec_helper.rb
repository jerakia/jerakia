$:.insert(0, File.join([File.dirname(__FILE__), "..", "lib"]))

JERAKIA_ROOT=File.expand_path('..', File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'mocha'
require 'jerakia'


RSpec.configure do |c|
    c.mock_with :mocha
end


