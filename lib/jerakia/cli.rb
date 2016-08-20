require 'thor'
require 'jerakia'
require 'json'
require 'yaml'

class Jerakia
  class CLI < Thor
    desc 'lookup [KEY]', 'Lookup [KEY] with Jerakia'
    option :config,
           aliases: :c,
           type: :string,
           desc: 'Configuration file'
    option :policy,
           aliases: :p,
           type: :string,
           default: 'default',
           desc: 'Lookup policy'
    option :namespace,
           aliases: :n,
           type: :string,
           default: '',
           desc: 'Lookup namespace'
    option :type,
           aliases: :t,
           type: :string,
           default: 'first',
           desc: 'Lookup type'
    option :scope,
           aliases: :s,
           type: :string,
           desc: 'Scope handler',
           default: "metadata"
    option :scope_options,
           type: :hash,
           desc: "Key/value pairs to be passed to the scope handler"
    option :merge_type,
           aliases: :m,
           type: :string,
           default: 'array',
           desc: 'Merge type'
    option :log_level,
           aliases: :l,
           type: :string,
           desc: 'Log level'
    option :verbose,
           aliases: :v,
           type: :boolean,
           desc: "Print verbose information"
    option :debug,
           aliases: :D,
           type: :boolean,
           desc: 'Debug information to console, implies --log-level debug'
    option :trace,
           type: :boolean,
           desc: 'Output stacktrace to stdout'
    option :metadata,
           aliases: :d,
           type: :hash,
           desc: 'Key/value pairs to be used as metadata for the lookup'
    option :schema,
           aliases: :S,
           type: :boolean,
           desc: 'Enable/disable schema lookup, default true',
           default: true
    option :output,
           aliases: :o,
           type: :string,
           default: 'json',
           desc: 'Output format, yaml or json'


    def lookup(key)

      case true
      when options[:verbose]
        loglevel = "verbose"
        logfile  = STDOUT
      when options[:debug]
        loglevel = "debug"
        logfile  = STDOUT
      else
        logfile = nil
        loglevel = options[:log_level]
      end

      begin

        jac = Jerakia.new({
          :config   => options[:config],
          :logfile  => logfile,
          :loglevel => loglevel,
          :trace    => options[:trace],
        })
        req = Jerakia::Request.new(
          :key           => key,
          :namespace     => options[:namespace].split(/::/),
          :policy        => options[:policy].to_sym,
          :lookup_type   => options[:type].to_sym,
          :merge         => options[:merge_type].to_sym,
          :metadata      => options[:metadata] || {},
          :scope         => options[:scope].to_sym,
          :scope_options => options[:scope_options],
          :use_schema    => options[:schema],
        )


        answer = jac.lookup(req)
        case options[:output]
        when 'json'
          puts answer.payload.to_json
        when 'yaml'
          puts answer.payload.to_yaml
        end
      rescue Jerakia::Error => e
        STDERR.puts "Error(#{e.class}): #{e.message}"
        STDERR.puts e.backtrace.join("\n") if options[:trace]
        exit 1
      end
    end

    desc 'version', 'Version information'
    def version
      puts Jerakia::VERSION
    end
  end
end
