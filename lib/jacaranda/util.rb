class Jacaranda
  module Util
    class << self
      def autoload(path,mod)
        Jacaranda::Log.debug "autoloading #{path} #{mod}"
        require "jacaranda/#{path}/#{mod.to_s}"
      end
    end
  end
end
