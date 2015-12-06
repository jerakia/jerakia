---
layout: minimal
---


# Lookup Plugins

## Introduction

Lookup plugins are a way to extend the functionality of [Jerakia lookups](/lookups).

Within a lookup we have access to both the request and all scope data sent by the requestor. Having access to read and modify these gives us a great deal of flexibility. Jerakia policies are written in Ruby DSL so there is nothing stopping you from putting any amount of functionality directly in the lookup. However, that makes for rather long and complex policies and isn’t easy to share or re-use. The recommended way therefore to add extra functionality to a lookup is to use the plugin mechanism. 

Custom lookup plugins are installed into the `plugindir` location in the [configuration](/basics/configure) and are searched relative to this path as `jerakia/lookup/plugin/<name>.rb`.  Core plugins are installed with the main code base but used in the same way.

To use a plugin in a lookup it must be loaded using the :use parameter to the lookup block, for example to load the [`hiera` plugin](/plugins/hiera) into your lookup you need to format your lookup block as;

{% highlight ruby %}
lookup :default, :use => :hiera do
  ...
end
{% endhighlight %}

If you want to use more than one plugin, the argument to :use can also be an array

{% highlight ruby %}
lookup :default, :use => [ :hiera, :mystuff ] do
  ...
end
{% endhighlight %}

Once a plugin is loaded into the lookup, it exposes it’s methods in the plugin.name namespace. For example, the hiera plugin has a method called rewrite_lookup which rewrites the lookup key and drops the namespace from the request, as described above. So to implement this functionality we would call the method using the plugin mechanism;

{% highlight ruby %}
lookup :default, :use => :hiera do
  ...
  plugin.hiera.rewrite_lookup
end
{% endhighlight %}

## Further reading

See the blog post [Extending Jerakia with Lookup Plugins](http://www.craigdunn.org/2015/09/extending-jerakia-with-lookup-plugins/) for more information on building lookup plugins.
