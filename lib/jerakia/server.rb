require 'sinatra'
require 'jerakia'
require 'thin'
class Jerakia
  class Server

    @jerakia = nil
    @config = {}

    def jerakia
      self.class.jerakia
    end

    class << self

      def default_config
        {
        'bind' => '127.0.0.1',
        'port' => '9843',
        }
      end

      def jerakia
        @jerakia
      end

      def start(opts)
        @jerakia = Jerakia.new(opts)
        require 'jerakia/server/rest'
        @config = default_config.merge(Jerakia.config[:server] || {})
        Thin::Logging.logger=Jerakia.log.logger
        Jerakia::Server::Rest.set :bind, @config['bind']
        Jerakia::Server::Rest.set :port, @config['port']
        Jerakia::Server::Rest.run!
      end
    end
  end
end
