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
      unless request.namespace.empty?
        request.key.prepend("#{request.namespace.join('::')}::")
      end
    end

    def calling_module
      request.key.split('::')[0]
    end
  end
end
