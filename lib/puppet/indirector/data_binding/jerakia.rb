require 'puppet/indirector/code'
require 'jerakia'
require 'json'

class Puppet::DataBinding::Jerakia < Puppet::Indirector::Code
  desc "Data binding for Jerakia"

  attr_reader :jerakia
  attr_reader :policy

  def initialize(*args)
    @jerakia=::Jerakia.new

    # Currently defaulting the policy to "puppet" - we should change this.
    @default_policy = @jerakia::config["puppet"]["default_policy"] || "puppet"
    super
  end

  def find(request)

    lookupdata=request.key.split(/::/)
    key=lookupdata.pop
    namespace=lookupdata
    metadata =  request.options[:variables].to_hash
    policy=metadata[:jerakia_policy] || @default_policy
    jacreq = Jerakia::Request.new(
      :key => key,
      :namespace => namespace,
      :policy => policy,
      :lookup_type => :first,
      :metadata => {}
    )
    answer = jerakia.lookup(jacreq)
    answer.payload
  end
end

