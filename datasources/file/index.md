---
layout: default
---

# Datasources

## File datasource

The file data source performs hierarchical searches across YAML or JSON formatted files and searches for the lookup key

### Options

* `:format`  The file format, one of :yaml and :json (other formats are pluggable)
* `:docroot` The root of the documents
* `:searchpath` An array specifying the order of hierarchical lookups.  Entries starting with an alphanumerical character will be relative from `docroot`, paths starting with `/` will be absolute.
* `:extension` Overrides the default extension (eg: yml) for the file format chosen
* `:enable_caching` true or false, whether to cache the contents of files

### Example 

{% highlight ruby %}
lookup :foo do
  datasource :file, {
    :format => :yaml,
    :docroot => "/var/lib/jerakia/data",
    :searchpath => [
      scope[:certname],
      scope[:environment],
      'global'
    ]
  }
end
{% endhighlight %}

### File system layout

Jerakia requests consist of a lookup key and an array representing the namespace.  By default the file data source will look for the lookup key in a filename based upon the `docroot`, `searchpath` and `namespace`.  For example if we use the above lookup directive with the following request:

{% highlight console %}
{
  :key       => "port",
  :namespace => [ "apache" ],
}
{% endhighlight %}

Assuming the scope has `certname => foo.acme.com` and `environment => development` then Jerakia will search for the key `port` in the following order

* `/var/lib/jerakia/data/foo.acme.com/apache.yaml`
* `/var/lib/jerakia/data/development/apache.yaml`
* `/var/lib/jerakia/data/global/apache.yaml`

More than one element used in the namespace will just expand the filesystem hierarchy, for example `:namespace => [ "profile", "web" ]` will result in something like `/var/lib/jerakia/data/global/profile/web.yaml`

### Hiera compatibility

Hiera maps lookups to file paths slightly differently by default.  If you are performing a lookup for `apache::port` from Puppet, Hiera will normally search for the key `apache::port` in a file corresponding to the hierarchy.    Jerakia searches for the lookup key `port`, in the namespace `apache` and therefore will look for the key in `apache.yaml`.

This is illustrated here;

_Hiera_
{% highlight console %}
$ cat /path/to/yaml/development.yaml
---
apache::port: 80
{% endhighlight %}

_Jerakia_
{% highlight console %}
$ cat /path/to/yaml/development/apache.yaml
---
port: 80
{% endhighlight %}

Users migrating from Hiera to Jerakia or just looking to test Jerakia on their existing Hiera filesystem layout [can use the hiera plugin](/plugins/hiera) to make the lookup rewrite the request so it gets searched in a hiera-style way.

### Fragments

A useful feature of Jerakia is the ability to break down your document into multiple files, especially where a file is becomming excessivly large.  The fragments feature was introduced in 0.4.0 and searches for a _.d_ directory matching the full pathname (minus extension) to your data file.  If found, Jerakia will concatenate the contents of all files below the _.d_ directory into one document before sending it to the format handler.

So in this example;

{% highlight console %}
/var/lib/jerakia/environment/dev/apache.yaml
/var/lib/jerakia/environment/dev/apache.d/01_www.example.com.yaml
/var/lib/jerakia/environment/dev/apache.d/01_www.foo.com.yaml
{% endhighlight %}

Jerakia will first scan the `apache.yaml` file, then traverse into the directory and concatenate (in alphabetical order) all the files encountered into one YAML document.  That means you can use YAML anchors across multiple files within the scope of the fragments as the YAML parser will only get one document.   Note that the `apache.yaml` file will always be parsed and included first.

