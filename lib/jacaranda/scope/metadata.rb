# Default scope handler, this handler creates the scope using the
# key value pairs from the metadata of the request object
#
# This is by far the simplest scope handler, others can be more
# complex and build the scope.value hash from MCollective, PuppetDB
# or other data sources
#
#
class Jacaranda::Scope
  module Metadata
    def create
      request.metadata.each_pair do |key, val|
        value[key] = val
      end
    end
  end
end

