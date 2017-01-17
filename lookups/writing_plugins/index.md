---
layout: default
---

# Writing Plugins

Lookup plugins are loaded as `jerakia/lookup/plugin/pluginname` from the ruby load path, meaning they can be shipped as a rubygem or placed under `jerakia/lookup/plugin` relative to the `plugindir` option in the configuration file.  The boilerplate template for a plugin is formed by creating a module with a name corresponding to your plugin name in the Jerakia::Lookup::Plugin class... in reality that looks a lot simpler than it sounds

{% highlight ruby %}
class Jerakia::Lookup::Plugin
  module Mystuff
  
  end
end 
{% endhighlight %}

We can now define methods inside this plugin that will be exposed to our lookups in the `plugin.mystuff` namespace.  For this example we are going to generate a dynamic hierarchy based on a top level variable `role`.  The variable contains a colon delimited string, and starting with the deepest level construct a hierarchy to the top. For example, if the role variable is set to `web::frontend::application_foo` we want to generate a search hierarchy of;

{% highlight none %}
/var/lib/jerakia/role/web/frontend/application_foo
/var/lib/jerakia/role/web/frontend
/var/lib/jerakia/role/web
{% endhighlight %}

To do this, we will write a method in our plugin class called `role_hierarchy` and then use it in our lookup.  First, let's add the method;

{% highlight ruby %}
class Jerakia::Lookup::Plugin
  module Mystuff

    def role_hierarchy
      role = scope[:role].split(/::/)
      tree = []
      until role.empty?
        tree << "role/#{role.join('/')}}"
        role.pop
      end
      tree
    end
  
  end
end 
{% endhighlight %}

We can now use this within our module by loading the <i>mystuff</i> plugin and calling our method as <i>plugins.mystuff.role_hierarchy</i>.  Here is the final lookup policy using our new plugin;

{% highlight ruby %}
lookup :default, :use => :mystuff do
  datasource :file, {
    format      => :yaml
    docroot     => "/var/lib/jerakia",
    searchpath  => [
      plugin.mystuff.role_hierarchy,    
      "host/#{scope[:hostname]",
      "environment/#scope[:environment]",
      "common",
    ]
  }
end
{% endhighlight %}

