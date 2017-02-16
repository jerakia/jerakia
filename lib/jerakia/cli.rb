require 'thor'
require 'jerakia'
require 'json'
require 'yaml'
require 'jerakia/cli/server'
require 'jerakia/cli/token'
require 'jerakia/cli/lookup'

class Jerakia
  class CLI < Thor
    include Jerakia::CLI::Server
    include Jerakia::CLI::Lookup
    include Jerakia::CLI::Token

    desc 'version', 'Version information'
    def version
      puts Jerakia::VERSION
    end
  end
end
