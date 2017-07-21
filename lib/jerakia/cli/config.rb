class Jerakia
  class CLI < Thor
    module Config
      def self.included(thor)
        thor.class_eval do
          desc 'config <options>', 'Print the runtime configuration options'
          option :config,
                 aliases: :c,
                 type: :string,
                 desc: 'Configuration file'
          def config
            require 'yaml'
            jerakia = Jerakia.new(:config => options[:config])
            puts jerakia.config.to_hash.to_yaml
          end
        end
      end
    end
  end
end
