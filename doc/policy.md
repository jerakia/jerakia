## Jacaranda Policies ##

### Introduction ###

Each search request is run aganst a specific search policies.  Search policies are used to defined a set of lookups to resolve data.  A simple policy can be defined as follows

`/etc/jacaranda/policy.d/puppet.rb`:

    policy :puppet do
    
      lookup :default do
        datasource :file, {
          :format => :yaml,
          :docroot => '/etc/jacaranda/data',
          :searchpath => [
            "#{scope[:environment]}",
            'global',
            'common'
          ]
        }
      end
    
    end

A policy definition can contain many lookups which will be in in order.

## Lookups ##

Lookup blocks define where and how to source the data.  At a minmum a lookup block must specify a `datasource` to pass the request to. Data sources can optionally take a hash of arguments.



 
