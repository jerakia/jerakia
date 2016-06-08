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

    def autorun
      if request.namespace.length > 0
        request.key.prepend("#{request.namespace.join('::')}::")
      end
      request.namespace=[]
    end

    def rewrite_lookup
      Jerakia.log.debug("DEPRECATION NOTICE: The use of plugin.hiera.rewrite_lookup is now deprecated and is automatically executed when the plugin is loaded")
    end

    def calling_module
      request.key.split('::')[0]
    end
  end
end
