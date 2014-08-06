# This is a proof of concept, and highly experimental to enable a data binding
# that talks to Jacaranda's REST API.  At present we only pass the environment
# from the scope as the whole scope hash is too large for the HTTP request.
#
# This may or may not be supported in future versions but feel free to contribute :)
#
require 'puppet/indirector/code'
require 'rest_client'
require 'jacaranda'
require 'json'

class Puppet::DataBinding::Jacaranda_rest < Puppet::Indirector::Code
  desc "Data binding for Jacaranda"

  attr_reader :jacaranda
  attr_reader :jacaranda_url
  attr_reader :policy

  def initialize(*args)
    @jacaranda=::Jacaranda.new
    @jacaranda_url=@jacaranda.config.server_url
    @policy = "puppet"
    super
  end

  def find(request)

    lookupdata=request.key.split(/::/)
    key=lookupdata.pop
    namespace=lookupdata

    #metadata =  request.options[:variables].to_hash
 
    metadata = {
      :environment => request.options[:variables].environment,
    }
    payload={
      :namespace => namespace,
      :lookup_type => :first,
      :metadata => metadata,
    }.to_json
    response = RestClient.get "#{jacaranda_url}/#{policy}/#{key}", :params => { :payload => payload }
    response
  end
end

