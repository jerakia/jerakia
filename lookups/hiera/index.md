---
layout: default
---


# Lookup Plugins

## Hiera

Jerakia has the concept of a namespace and a key, by default the file lookup datasource will look for _key_ in `<datadir>/<scope>/<namespace>.yaml` - in order to retain Hieras way of doing things, which is to lookup `<namespace>::<key>` in a file called `<datadir>/<scope>.yaml` a plugin _hiera_ has been provided.  To enable this in your lookup simply add the directive to the lookup block and the request key and namespace will automatically get re-written on the fly

{% highlight ruby %}
      lookup :default, :use => :hiera do
        datasource :file, {
          :format => :yaml,
          :docroot => '/var/lib/jerakia/data',
          :searchpath => [
            scope[:environment],
            global
          ]
      end
    end
{% endhighlight %}


There is no need to call a method using the hiera plugin.  By including it in the lookup, the `autorun` method of the plugin will automatically rewrite the lookup.


