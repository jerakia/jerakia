---
layout: minimal
---

# Jerakia Lookups

Lookup blocks define where and how to source the data.  At a minmum a lookup block must specify a `datasource` to pass the request to. Data sources can optionally take a hash of arguments.  Look at each datasource's documentation for information on what options they support.

A policy can contain many lookups and each one is evaluated in order within the policy.

Supported methods are

* `datasource, {opts}` data source with corresponding options
* `invalidate` disable this lookup
* `scope` return the scope object
* `output_filter` add an output handler to this request
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

## Defining Lookups

Lookups are defined inside policies using the `lookup` method.

{% highlight ruby %}
lookup :main do
end
{% endhighlight %}

The lookup method also supports the `:use` flag to [load plugins](/lookup/plugins)

{% highlight ruby %}
lookup :main, :use => :hiera do
end
{% endhighlight %}


## Lookup Methods

#### `datasource`

The datasource option takes a datasource name as the first argument and options to be passed to the datasource as a hash in the second argument

{% highlight ruby %}
datasource :<datasource>, { :opt => value, :opt => value }
{% endhighlight %}

Example:

{% highlight ruby %}
datasource :file, {
  :format => :yaml,
  :docroot => '/var/lib/jerakia/data',
  :searchpath => [
    scope[:certname],
    scope[:environment],
    'global',
  ]
},
{% endhighlight %}

#### `confine` and `exclude`

The `confine` and `exclude` lookup methods allow you to specify when a lookup should be run or should be skipped. When you have multiple lookups defined in a policy you may not want to always run all lookups.

Both arguments take a subject as the first argument and the criteria as the second argument.

For example, to only run a lookup if the namespace matches `apache` you can specify

{% highlight ruby %}
lookup :special do
   ...
   confine request.namespace[0], "apache"
end
{% endhighlight %}

The second argument can be a regex, and multiple criteria can be passed in as an array, eg:

{% highlight ruby %}
lookup :special do
  ...
  confine request.namespace[0], [
    /website_.*/,
    "apache",
    "php"
  ]
end
{% endhighlight %}

The `exclude` method has the oposite effect of `confine` and will cause the lookup to be run _unless_ the condition matches.

#### `invalidate`

Calling the `invalidate` method will cause Jerakia to skip this lookup and proceed to the next one (if applicable)

#### `stop`

The stop method will prevent Jerakia from running any more lookups after the containing lookup, however, it only has effect if the containing lookup is valid.  If the lookup is invalidated with `confine`, `exclude` or `invalidate` then Jerakia will proceed to the next lookup.

#### `output_filter`

The `output_filter` lookup method will send the data returned from the datasource to the response filter specified as the first argument, for example, if you are using the eyaml encryption response filter, then you need an output_filter method to enable that in your lookup

{% highlight ruby %}
lookup :main do
  ...
  output_filter :encryption
end
{% endhighlight %}

#### `scope`

The scope method returns the key/value scope data from the requestor as a hash.

{% highlight ruby %}
scope[:value]
{% endhighlight %}





