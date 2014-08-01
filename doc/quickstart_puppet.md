## Quickstart ##

### Install jacaranda ###

    gem install jacaranda 

### Define a policy ###

To define a new policy, which we will call _puppet_  edit `/etc/jacaranda/policy.d/puppet.rb` and add the following


    policy :puppet do
    
      lookup :default do
        datasource :file, {
          :format => :yaml,
          :docroot => '/etc/jacaranda/data',
          :searchpath => [
            scope[:environment],
            global
          ]
      end
    
    end

### Add some data ###
 
Edit `/etc/jacaranda/data/global/apache.yml` and add the following

    ---
    port: 9080
    docroot: /var/www/html


### Configure Puppet data bindings ###

Edit `/etc/puppet.conf` and add the following:

    data_binding_terminus = jacaranda

### Write a test class in Puppet ###

    class apache ( $port='default' ) {
      notify { $port: }
    }

### Run puppet ###


## Hiera Compatiblity ##

Jacaranda has the concept of a namespace and a key, by default the file lookup datasource will look for _key_ in <datadir>/<scope>/<namespace>.yml - in order to retain Hieras way of doing things, which is to lookup <namespace>::<key> in a file called <datadir>/<scope>.yml a plugin _hiera_compat_ has been provided.  To enable this in your lookup simply add the directive to the lookup block and the request key and namespace will automatically get re-written on the fly

      lookup :default do
        datasource :file, {
          :format => :yaml,
          :docroot => '/etc/jacaranda/data',
          :searchpath => [
            scope[:environment],
            global
          ]
        hiera_compat
      end
    
    end

## Other useful plugins ##

Jacaranda lookup plugins can be written and used to extend the functionality available in the lookup block.  One such shipped plugin is _confine_ which extends the lookup functionality with `exclude` and `confine` methods to invalidate the lookup under a set of circumstances.  For example

    policy :puppet do

      lookup :default do
        datasource :file, {
          :format => :yaml,
          :docroot => '/etc/jacaranda/data',
          :searchpath => [
            scope[:environment],
            global
          ]
        hiera_compat
        exclude :environment, "dev"
      end

      lookup :special do
        datasource :file, {
          :format => :json,
          :docroot => '/etc/myapp/data',
          :searchpath => [
            scope[:special_thing'],
            scope[:environment],
            global
          ]
        hiera_compat
        confine :calling_module, "specialapp"
      end

    end

The above, albeit slightly unrealistic example, demonstrates using two lookups - default, and special.  The default lookup will always be used except in the dev environment, and the special lookup will only be used when the calling_module metadata parameter is set to 'specialapp'.  This plugin allows you to effectivly route different requests to different places.

