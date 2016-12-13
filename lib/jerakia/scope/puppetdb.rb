require 'lookup_http'
class Jerakia::Scope
  module Puppetdb
    def create
      yaml_file = request.scope_options['file'] || './jerakia_scope.yaml'
      puppetdb_host = request.scope_options['puppetdb_host'] || 'localhost'
      puppetdb_port = request.scope_options['puppetdb_port'] || 8080
      puppetdb_api  = request.scope_options['puppetdb_api'] || 4
      node = request.scope_options['node']

      raise Jerakia::Error, "Must pass the option node to the puppetdb scope handler" unless node

      connection_opts = {
        :host => puppetdb_host,
        :port => puppetdb_port,
        :output => 'json',
        :ignore_404 => true
      }.merge(request.scope_options['puppetdb_http_opts'] || {})

      puppetdb_con = LookupHttp.new(connection_opts)
      
      case puppetdb_api
      when 4
        path = "/pdb/query/v4/nodes/#{node}/facts"
      else
        raise Jerakia::Error, "Unsupported PuppetDB API version, #{puppetdb_api}"
      end

      Jerakia.log.debug("Sending HTTP query to PuppetDB #{puppetdb_host}:#{puppetdb_port} at path #{path}")

      response = puppetdb_con.get_parsed(path)

      raise Jerakia::Error, "PuppetDB returned no data for node #{node}" unless response.is_a?(Array)

      response.each { |r| value[r['name'].to_sym] =  r['value'] }
    end
  end
end
