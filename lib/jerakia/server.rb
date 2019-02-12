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
        'bind'      => '127.0.0.1',
        'port'      => '9843',
        'token_ttl' => 300,
	'tokens'     => [],
        }
      end

      def parse_tokens(tokens)
        tokens.each do |t|
          unless t.match(/^\w+:\w+$/)
            raise Jerakia::ArgumentError, "Invalid token #{t}: must be <api_id>:<token> and be alphanumeric"
          end
	  api_id, token_string = t.split(/:/)
	  unless Jerakia::Server::Auth.exists?(api_id)
            Jerakia::Server::Auth.create(api_id, token_string)
            Jerakia.log.verbose("Stored token for #{api_id}")
          else
	    stored = Jerakia::Server::Auth.get_entry(api_id)
	    unless stored.token == token_string
              raise Jerakia::Error, ("Supplied token #{api_id}, conflicts with existing token")
	    end
          end
        end
      end

      def jerakia
        @jerakia
      end

      def start(opts, server_opts={})
        @jerakia = Jerakia.new(opts)
        require 'jerakia/server/rest'
        @config = default_config.merge(Jerakia.config[:server] || {}).merge(server_opts)
        parse_tokens(@config['tokens'])

        Thin::Logging.logger=Jerakia.log.logger
        Jerakia::Server::Rest.set :bind, @config['bind']
        Jerakia::Server::Rest.set :port, @config['port']
        Jerakia.log.verbose("Starting Jerakia on #{@config['bind']}:#{@config['port']}")
        Jerakia::Server::Rest.run!
      end
    end
  end
end
