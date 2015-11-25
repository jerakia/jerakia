---
layout: minimal
---

# Jerakia Lookups

Lookup blocks define where and how to source the data.  At a minmum a lookup block must specify a `datasource` to pass the request to. Data sources can optionally take a hash of arguments.  Look at each datasource's documentation for information on what options they support.

Supported methods are

* `datasource, {opts}` data source with corresponding options
* `invalidate` disable this lookup
* `scope` return the scope object
* `output_handler` add an output handler to this request
* `stop` Do not proceed to the next lookup _if this lookup is deemed valid_, regardless of whether data is returned
* `confine` Confine this lookup to a set of criteria
* `exclude` Exclude this lookup if the criteria is matched

## Example ##

Here is an example of a Jerakia lookup contained within a policy

{% highlight ruby %}
policy :default do
  lookup :main do
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
  end
end
{% endhighlight %}     




 

