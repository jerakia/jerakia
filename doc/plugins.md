# Lookup Plugins #

## Introduction ##

Lookup plugins expand the functionality of Jerakia lookups and have the ability to read and maniplate the lookup request.

## Installation ##

Lookups are loaded from `lib/jerakia/lookup/plugin/<name>.rb`.  They can either be shipped as rubygems or placed locally in the `plugindir` defined in `jerakia.yml` under the same relative filesystem structure

## Writing plugins ##

A plugin defines a set of methods in it's namespace that can access the lookup scope and request objects.  The boiler plate for a lookup function looks like

    class Jerakia::Lookup::Plugin
      module Myplugin
        def my_method
        ...
        end
      end
    end

## Using plugins ##

Plugins are loaded by using the `:use` argument to the lookup call, and their methods available using `plugin.name.method`  for example:

    lookup :default,  :use => :myplugin do
      ...
      plugin.myplugin.my_method
    end

The `:use` parameter also supports an array if you are using more than one plugin

    lookup :default, :use => [ :myplugin, :hiera ] do
    ...
    end

## Example ##

In this not highly imaginative example, we'll create a custom plugin called _mycorp_ that provides a method for auto-determining an environment name (not the puppet environment) based on the first letter of a hostname, eg: `pweb01 => prod` and `dweb01 => dev` and using that value in the search hierarchy.

`vim /etc/jerakia/lookup/plugin/mycorp.rb`

We are assuming your plugindir is set to `/etc`

    class Jerakia::Lookup
      module Mycorp
    
        def env
          case scope[:hostname][0]
          when "d"
            "dev"
          when "p"
            "prod"
          end
        end
    
      end
    end

Now we have created our lookup we can use it in a lookup as:

    lookup :default, :use => :mycorp do

      datasource :file, {
        :format         => :yaml,
        :docroot        => "/var/lib/jerakia",
        :enable_caching => true,
        :searchpath     => [
          "hostname/#{scope[:hostname]}",
          "environment/#{plugin.mycorp.env}",
          "common"
        ]
      end

    end

Let's expand on that example and use the rewrite_lookup method from the hiera plugin to make our lookups compatible with hiera...

    lookup :default, :use => [ :hiera, :mycorp ] do

      datasource :file, {
        :format         => :yaml,
        :docroot        => "/var/lib/jerakia",
        :enable_caching => true,
        :searchpath     => [
          "hostname/#{scope[:hostname]}",
          "environment/#{plugin.mycorp.env}",
          "common"
        ]
      end

      plugin.hiera.rewrite_lookup

    end

## Capabilities ##

Plugins are not only capable of reading the lookup request, they are capable of modifying it too (plugin.hiera.rewrite_lookup for example will delete the namespace and modify the key to make the datasource backend compatible with hiera layouts).  Each lookup is passed a copy of the request and scope objects therefore plugins from one lookup will not affect the scope or request of the next lookup.




