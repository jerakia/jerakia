require 'lookup_http'


class Jerakia::Datasource
  module Http

    def run
      #
      # Do the lookup

      Jerakia.log.debug("Searching key #{lookup.request.key} using the http datasource (#{whoami})")


      option :host,                { :type => String,  :mandatory => true }
      option :port,                { :type => Integer, :default => 80 }
      option :output,              { :type => String,  :default => 'json' }
      option :failure,             { :type => String,  :default => 'graceful' }
      option :ignore_404,          { :default => true }
      option :headers,             { :type => Hash }
      option :http_read_timeout,   { :type => Integer }
      option :use_ssl
      option :ssl_ca_cert,         { :type => String }
      option :ssl_cert,            { :type => String }
      option :ssl_key,             { :type => String }
      option :ssl_verify
      option :use_auth
      option :auth_user,           { :type => String }
      option :auth_pass,           { :type => String }
      option :http_connect_timeout,{ :type => Integer }
      option :paths,               { :type => Array, :mandatory => true }


      lookup_supported_params = [
        :host,
        :port,
        :output,
        :failure,
        :ignore_404,
        :headers,
        :http_connect_timeout,
        :http_read_timeout,
        :use_ssl,
        :ssl_ca_cert,
        :ssl_cert,
        :ssl_key,
        :ssl_verify,
        :use_auth,
        :auth_user,
        :auth_pass,
      ]
      lookup_params = options.select { |p| lookup_supported_params.include?(p) }
      http_lookup = LookupHttp.new(lookup_params)

      options[:paths].flatten.each do |path|
        Jerakia.log.debug("Attempting to load data from #{path}")
        return unless response.want?

        data=http_lookup.get_parsed(path)
        Jerakia.log.debug("Datasource provided #{data} (#{data.class}) looking for key #{lookup.request.key}")

        if data.is_a?(Hash)
          unless data[lookup.request.key].nil?
            Jerakia.log.debug("Found data #{data[lookup.request.key]}")
            response.submit data[lookup.request.key]
          end
        else
          unless options[:output] == 'plain' or options[:failure] == 'graceful'
            raise Jerakia::Error, "HTTP request did not return a hash for #{lookup.request.key} #{whoami}"
          end
          return data
        end

      end
    end
  end
end

