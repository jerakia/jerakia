class Jerakia::Lookup::PluginFactory

   def initialize 
     Jerakia.log.debug("Loaded plugin handler")
     @plugin_config = Jerakia.config[:plugins] || {}
   end


   def create_plugin_method(name, &block)
     self.class.send(:define_method, name, &block)
   end

   def register(name,plugin)
     begin
       require "jerakia/lookup/plugin/#{name}"
     rescue LoadError => e
       raise Jerakia::Error, "Cannot load plugin #{name}, #{e.message}"
     end

     
     plugin.activate(name)
     create_plugin_method(name) do
       plugin
     end
     if plugin.respond_to?('autorun')
       Jerakia.log.debug("Found autorun method for plugin #{name}, executing")

       if plugin.method('autorun').arity == 1
         plugin.autorun (@plugin_config[name.to_s] || {} )
       else      
         plugin.autorun
       end
     end
   end

end

  
