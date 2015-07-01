# This plugin reformats the lookup key according to a puppet's
# Hiera system, so instead of looking up <key> in <path>/<namespace>.yml
# we lookup <namespace>::<key> in <path>.yml
#
# This is a useful plugin for people wanting to test drive Jacaranda
# but maintain an existing hiera filesystem layout and naming convention
# within the source data.
#
class Jacaranda::Lookup
  module Plugin
    def hiera_compat
      request.key.prepend("#{request.namespace.join('::')}::")
      request.namespace=[]
    end

    def calling_module
      request.namespace.join('::') 
    end
  end
end


