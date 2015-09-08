class Jerakia::Lookup::PluginFactory

   def initialize 
     Jerakia.log.debug("Loaded plugin handler")
   end


   def create_plugin_method(name, &block)
     self.class.send(:define_method, name, &block)
   end

   def register(name,plugin)
     require "jerakia/lookup/plugin/#{name}"
     plugin.activate(name)
     create_plugin_method(name) do
       plugin
     end
   end

end

  
