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
      if request.namespace.length > 0
        request.namespace[0]
      else
        Jacaranda.log.error("hiera_compat plugin tried to use calling_module but there is no namespace declared.  Ensure that calling_module is called before hiera_compat in the policy")
      end
    end
  end
end


