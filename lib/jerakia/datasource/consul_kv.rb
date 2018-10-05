require 'diplomat'
require 'uri'

class Jerakia::Datasource::Consul_kv < Jerakia::Datasource::Instance

  # datacenter option sets the :dc method in the Diplomat
  # request to perform a consul lookup using a particular
  # datacenter
  #
  option(:datacenter) { |str| str.is_a?(String) }

  # to_hash, when used with recursive, will consolidate the
  # results into a hash, instead of an array
  #
  option(:to_hash, :default => true) { |opt|
    [ TrueClass, FalseClass ].include?(opt.class)
  }

  # Recursive will return the entire data structure from console
  # rather than just the requested key
  #
  option(:recursive, :default => false) { |opt|
    [ TrueClass, FalseClass ].include?(opt.class)
  }

  # The searchpath is the root path of the request, which will
  # get appended with the namespace, and key if applicable.
  # We allow this option to be ommited in case the lookup path
  # starts at the namesapce.
  #
  option(:searchpath, :default => ['']) { |opt| opt.is_a?(Array) }

  # Set any consul parameters against the Diplomat class
  #
  # These values are set in jerakia.yaml and are loaded directly
  # to the class when we load the datasource for the first time.
  #
  consul_config = Jerakia.config['consul']
  if consul_config.is_a?(Hash)
    Diplomat.configure do |config|
      config.url = consul_config['url'] if consul_config.has_key?('url')
      config.acl_token = consul_config['acl_token'] if consul_config.has_key?('acl_token')
      config.options = consul_config['options'] if consul_config['options'].is_a?(Hash)
    end
  end



  # Entrypoint for Jerakia lookups starts here.
  #
  def lookup

    Jerakia.log.debug("[datasource::console_kv] backend performing lookup for #{request.key}")
    paths = options[:searchpath].reject { |p| p.nil? }

    key = request.key
    namespace = request.namespace


    answer do |response|

      break if paths.empty?
      path = paths.shift.split('/').compact


      path << namespace
      path << key unless key.nil?

      diplomat_options = {
        :recurse => options[:recursive],
        :convert_to_hash => options[:to_hash],
        :dc => options[:datacenter],
      }

      begin
       key_path = path.flatten.join('/')
       Jerakia.log.debug("[datasource::consul_kv] Looking up #{key_path} with options #{diplomat_options}")
       result = Diplomat::Kv.get(key_path, diplomat_options)
      rescue Diplomat::KeyNotFound => e
        Jerakia.log.debug("NotFound encountered, skipping to next path entry")
        next
      rescue Faraday::ConnectionFailed => e
        raise Jerakia::Error, "Failed to connect to consul service: #{e.message}"
      end
      response.submit result
    end
  end
end
