### Datasources ###

## File ##

# Description #

The file data source performs hierarchical searches across YAML or JSON formatted files and searches for the lookup key

# Options #

* `:format`  The file format, one of :yaml and :json
* `:docroot` The root of the documents
* `:searchpath` An array specifying the order of hierarchical lookups.  Entries starting with an alphanumerical character will be relative from `docroot`, paths starting with `/` will be absolute.
* `:extension` Overrides the default extension (eg: yml) for the file format chosen
* `:enable_caching` true or false, whether to cache the contents of files

# Example #

    lookup :foo do
      datasource :file, {
        :format => :yaml,
        :docroot => "/etc/jerakia/data",
        :searchpath => [
          scope[:certname],
          scope[:environment],
          'global'
        ]
      }
    end

# File system layout #

Jerakia requests consist of a lookup key and an array representing the namespace.  By default the file data source will look for the lookup key in a filename based upon the `docroot`, `searchpath` and `namespace`.  For example if we use the above lookup directive with the following request:

    {
      :key => "port",
      :namespace => [ "apache" ],
    }

Assuming the scope has `certname => foo.acme.com` and `environment => development` then Jerakia will search for the key `port` in the followint order

* `/etc/jerakia/data/foo.acme.com/apache.yaml`
* `/etc/jerakia/data/development/apache.yaml`
* `/etc/jerakia/data/global/apache.yaml`

More than one element used in the namespace will just expand the filesystem hierarchy, for example `:namespace => [ "profile", "web" ]` will result in something like `/etc/jerakia/data/global/profile/web.yaml`

# hiera_compat #

Hiera has a slightly different way of working, as the file name is made out of the scope and hierarchy, with namespacing implied in the look up key.  In Hiera for example we would store the key `apache::port` in a file called `global.yaml`.  This default behaviour can lead to very large YAML files in larger environments, hence the decision to change this convention in Jerakia.  However, for users wishing to maintain their Hiera filesystem layout there is a lookup plugin called _hiera_compat_ which will perform rewrites on the request object on the fly to provide compatibility to Hiera.

So, if we use this lookup block

    lookup :foo do
      datasource :file, {
        :format => :yaml,
        :docroot => "/etc/jerakia/data",
        :searchpath => [
          scope[:certname],
          scope[:environment],
          'global'
        ]
       hiera_compat
      }
    end

When the following request is recieved

    {
      :key => "port",
      :namespace => [ "apache" ],
    }

The lookup will get automatically rewritten to be

    {
      :key => "apache::port",
      :namespace => '',
    }

This will change the behaviour of Jerakia, which will now look for the key `apache::port` in the following files 

* `/etc/jerakia/data/foo.acme.com.yaml`
* `/etc/jerakia/data/development.yaml`
* `/etc/jerakia/data/global.yaml`

Unless you are migrating or sharing data with Hiera, it's recommended to use the default filesystem layout.

