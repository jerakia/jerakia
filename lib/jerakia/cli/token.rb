class Jerakia
  class CLI < Thor
    module Token
      def self.included(thor)
        thor.class_eval do
          desc 'token [SUBCOMMAND] <api id> <options>', 'Create, view and manage token access'
          option :quiet,
                 aliases: :q,
                 type: :boolean,
                 desc: 'Supress explanatory output'

          def token(subcommand, api_id=:all)
            Jerakia.new
            require 'jerakia/server/auth'

            unless subcommand == 'list'
              if api_id == :all
                help :token
                STDERR.puts "Error: No API ID provided"
                exit 1
              end
            end

            if ['enable', 'disable', 'regenerate', 'delete'].include?(subcommand)
              unless Jerakia::Server::Auth.exists?(api_id)
                STDERR.puts "No such API ID #{api_id}"
                exit 1
              end
            end

            case subcommand
            when 'create'
              token = Jerakia::Server::Auth.create(api_id)
              unless options[:quiet]
                puts "Copy the following token to the application, it must be sent in the Authorization header. This token cannot be retrieved later, if you have lost the token for an application you can create a new one with 'jerakia token regenerate <api id>'\n\n"
              end
              puts token

            when 'list'
              entries = Jerakia::Server::Auth.get_tokens
              printf("%-20s %-28s %s\n\n","API Identifier","Last Seen", "Status")
              entries.each do |entry|
                status = entry.active ? 'active' : 'disabled'
                printf("%-20s %-28s %s\n", entry.api_id, entry.last_seen.strftime('%F %X'), status)
              end

            when 'disable'
              Jerakia::Server::Auth.disable(api_id)
            when 'enable'
              Jerakia::Server::Auth.enable(api_id)
            when 'delete'
              Jerakia::Server::Auth.destroy(api_id)
            when 'regenerate'
              token('delete', api_id)
              token('create', api_id)
            else
              STDERR.puts "Unknown subcommand #{subcommand}.  Valid commands are list, create, delete, regenerate, disable, enable"
            end
          end
        end
      end
    end
  end
end
