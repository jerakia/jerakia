# This plugin reformats the lookup key according to a puppet's
# Hiera system, so instead of looking up <key> in <path>/<namespace>.yaml
# we lookup <namespace>::<key> in <path>.yaml
#
# This is a useful plugin for people wanting to test drive Jerakia
# but maintain an existing hiera filesystem layout and naming convention
# within the source data.
#
class Jerakia::Lookup::Plugin
  module Hiera
    def rewrite_lookup
      request.key.prepend("#{request.namespace.join('::')}::")
      request.namespace=[]
    end

    def calling_module
      if request.namespace.length > 0
        request.namespace[0]
      else
        Jerakia.log.error("hiera_compat plugin tried to use calling_module but there is no namespace declared.  Ensure that calling_module is called before hiera_compat in the policy")
      end
    end
  end
end


