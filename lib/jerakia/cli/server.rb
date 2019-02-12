class Jerakia
  class CLI < Thor
    module Server
      def self.included(thor)
        thor.class_eval do
          desc 'server <options>', 'Start the Jerakia REST server'
          option :port,
                 aliases: :p,
                 type: :string,
                 desc: 'Specify alternate port to bind to (default 9843)'

          option :bind,
                 aliases: :b,
                 type: :string,
                 desc: 'Specify alternate address to bind to (default 127.0.0.1)'

          option :token_ttl,
                 aliases: :t,
                 type: :string,
                 desc: 'Specify token TTL (default 300)'

	  option :create_tokens,
	         aliases: :T,
		 type: :string,
		 desc: 'Specify tokens to be created, existing tokens will be ignored'

          option :config,
                 aliases: :c,
                 type: :string,
                 desc: 'Configuration file'
          option :log_level,
                 aliases: :l,
                 type: :string,
                 desc: 'Log level'
          option :verbose,
                 aliases: :v,
                 type: :boolean,
                 desc: 'Log to STDOUT in verbose mode'
          option :debug,
                 aliases: :D,
                 type: :boolean,
                 desc: 'Log to STDOUT in debug mode'
          def server

            case true
            when options[:verbose]
              loglevel = 'verbose'
              logfile  = STDOUT
            when options[:debug]
              loglevel = 'debug'
              logfile  = STDOUT
            else
              logfile = nil
              loglevel = options[:log_level]
            end

            jerakia_opts = {
              :config   => options[:config],
              :logfile  => logfile,
              :loglevel => loglevel,
              :trace    => options[:trace],
            }


	    tokens = options[:create_tokens] ? options[:create_tokens].split(/,/) : []

            server_opts = {
              "port"      => options[:port],
              "bind"      => options[:bind],
              "token_ttl" => options[:token_ttl],
	      "tokens"    => tokens,
            }.reject { |k,v| v.nil? }

            require 'jerakia/server'
            Jerakia::Server.start(jerakia_opts, server_opts)
          end
        end
      end
    end
  end
end
