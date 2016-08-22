## Jerakia Policies ##

### Introduction ###

Each search request is run aganst a specific search policies.  Search policies are used to defined a set of lookups to resolve data.  A simple policy can be defined as follows

`/etc/jerakia/policy.d/puppet.rb`:

    policy :puppet do
    
      lookup :default do
        datasource :file, {
          :format => :yaml,
          :docroot => '/etc/jerakia/data',
          :searchpath => [
            "#{scope[:environment]}",
            'global',
            'common'
          ]
        }
      end
    
    end

Because polcies are written in native ruby, this makes them extremely customizable to adapt to a wide range of complex use cases.

A policy definition can contain many lookups which will be in in order.

## Lookups ##

Lookup blocks define where and how to source the data.  At a minmum a lookup block must specify a `datasource` to pass the request to. Data sources can optionally take a hash of arguments.  Look at each datasource's documentation for information on what options they support.

Supported methods are

* `datasource, {opts}` data source with corresponding options
* `invalidate` disable this lookup
* `scope` return the scope object
* `output_handler` add an output handler to this request
* `stop` Do not proceed to the next lookup _if this lookup is deemed valid_, regardless of whether data is returned
* `confine` Confine this lookup to a set of criteria
* `exclude` Exclude this lookup if the criteria is matched

### Scope object ###

Scope is a key value set that can be used to determine the behaviour of a lookup.  By default the scope is built out of the metadata sent with the request, but can be loaded from a variety of scope handlers such as PuppetDB.  Scopes can be accessed directly in the lookup using the scope function eg: `scope[:environment]`

### Plugins ###

Additionally, lookup functionality can be expanded with a variety of shipped or custom plugins.  Plugins have access to a copy of the request object and therefore can inspect and make changes to all manor of things contained within it.  Shipped plugins currently include

* `hiera` : Rewrite the lookup to emulate Hiera's filesystem layout (see [The file datastore](datasources/file.md))

Custom plugins can be used using the `use` option to the lookup block, and plugins methods are available as `plugin.<name>.<method>` from the lookup. Plugins have the ability to read and modify any part of the request, including the scope.  Eg:

    lookup :default, :use => :hiera do
      datasource :file, {
        ...
      }
      plugin.hiera.rewrite_lookup
    end

    

### Output Handler ###

Optionally, you can specify one or more output handlers.  Output handlers are passed the response object before they are compiled into an answer and returned to the requestor.  One shipped output handler is encryption which passes every response value through a filter to determine if decryption is required, and if so, uses eyaml (from heira-eyaml) to decrypt the data

### Ordering ###

The ordering of lookups is important - they will be performed in the order that they are read.  Since plugins have the ability to rewrite and modify the lookup request, ordering may be important for those too and you should consult the relevant plugin docs.

## Example ##

Here is an example of a slightly more complicated policy that makes use of some of the above

    policy :puppet do
    
      lookup :special do {
        datasource :file, {
          :format => :yaml,
          :docroot => '/var/specialapp/data',
          :searchpath => [
            "scope[:environment]/config"
          ]
        }
        confine calling_module, "specialapp"
        stop
      end

      lookup :default, :use => :hiera do
        datasource :file, {
          :format => :yaml,
          :extension => 'yaml',
          :docroot => '/etc/jerakia/data',
          :searchpath => [
            scope[:certname],
            scope[:environment],
            'global',
          ]
          },
        plugin.hiera.rewrite_lookup
        output_handler :encryption
      }
    
      end
    end

In this, rather imaginative example, all lookup requests will be passed to the file datasource specified in the default lookup, except for requets that have calling_module set to 'specialapp'.  When calling_module is set to special_app the only lookup that will be used is `special`.   Here we are using  confine to effectivly route lookup requests.


     




 
