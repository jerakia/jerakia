# This is a proof of concept, and highly experimental to enable a data binding
# that talks to Jerakia's REST API.  At present we only pass the environment
# from the scope as the whole scope hash is too large for the HTTP request.
#
# This may or may not be supported in future versions but feel free to contribute :)
#
require 'puppet/indirector/code'
require 'rest_client'
require 'jerakia'
require 'json'

class Puppet::DataBinding::Jerakia_rest < Puppet::Indirector::Code
  desc 'Data binding for Jerakia'

  attr_reader :jerakia
  attr_reader :jerakia_url
  attr_reader :policy

  def initialize(*args)
    @jerakia = ::Jerakia.new
    @jerakia_url = @jerakia.config.server_url
    @policy = 'puppet'
    super
  end

  def find(request)
    lookupdata = request.key.split(/::/)
    key = lookupdata.pop
    namespace = lookupdata

    # metadata =  request.options[:variables].to_hash

    metadata = {
      :environment => request.options[:variables].environment
    }
    payload = {
      :namespace => namespace,
      :lookup_type => :first,
      :metadata => metadata
    }.to_json
    response = RestClient.get "#{jerakia_url}/#{policy}/#{key}", :params => { :payload => payload }
    response
  end
end
