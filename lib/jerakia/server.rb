require 'sinatra'
require 'jerakia'
require 'thin'
class Jerakia
  class Server

    def jerakia
      self.class.jerakia
    end

    class << self

      @jerakia = nil
      @config = {}

      attr_reader :config

      def default_config
        {
        'bind' => '127.0.0.1',
        'port' => '9843',
        'token_ttl' => 300,
        }
      end

      def jerakia
        @jerakia
      end

      def start(opts, server_opts={})
        @jerakia = Jerakia.new(opts)
        require 'jerakia/server/rest'
        @config = default_config.merge(Jerakia.config[:server] || {}).merge(server_opts)
        Thin::Logging.logger=Jerakia.log.logger
        Jerakia::Server::Rest.set :bind, @config['bind']
        Jerakia::Server::Rest.set :port, @config['port']
        Jerakia.log.verbose("Starting Jerakia on #{@config['bind']}:#{@config['port']}")
        Jerakia::Server::Rest.run!
      end
    end
  end
end
