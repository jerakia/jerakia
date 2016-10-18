# Jerakia::Lookup::PluginConfig
#
# This class is a simple wrapper class to expose configuration options
# from the global configuration file to lookup plugins.  It's exposed
# to the lookup as the config method.  Eg: config[:foo]
#
class Jerakia
  class Lookup
    class PluginConfig

      attr_reader :plugin_name
      attr_reader :config

      def initialize(plugin_name)
        @plugin_name = plugin_name
        @config = {}
        if Jerakia.config[:plugins].is_a?(Hash)
          @config = Jerakia.config[:plugins][plugin_name.to_s] || {}
        end
      end

      def [](key)
        config[key.to_s]
      end

    end
  end
end
        


