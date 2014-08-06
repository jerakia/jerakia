require 'puppet/indirector/code'
require 'jacaranda'
require 'json'

class Puppet::DataBinding::Jacaranda < Puppet::Indirector::Code
  desc "Data binding for Jacaranda"

  attr_reader :jacaranda
  attr_reader :policy

  def initialize(*args)
    @jacaranda=::Jacaranda.new

    # Currently defaulting the policy to "puppet" - we should change this.
    @policy = @jacaranda::config["puppet"]["default_policy"] || "puppet"
    super
  end

  def find(request)

    lookupdata=request.key.split(/::/)
    key=lookupdata.pop
    namespace=lookupdata

    metadata =  request.options[:variables].to_hash
    jacreq = Jacaranda::Request.new(
      :key => key,
      :namespace => namespace,
      :policy => policy,
      :lookup_type => :first,
      :metadata => {}
    )
    answer = jacaranda.lookup(jacreq)
    answer.payload
  end
end

