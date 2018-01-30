---
layout: default
---

# Output Filters

## dig

### Description

The `dig` output filter is used to dig into a returned data set and return a subset of the structure.  This is particularly useful if the end data source encapsulates the required data under some data structure that is not wanted.  For example, imagine a data source that returns key value pairs under a nested hash of "documents" and "settings", eg:

{% highlight json %}
{
  "document": {
    "settings": {
      "foo": "bar"
    }
  }
}
{% endhighlight %}

If we are only interested in the `settings` hash we can tell Jerakia to dig into the result and return just the subset that we need.  The `dig` output_filter takes an array as an argument, each element of the array corresponds to a key in the hash to dig through.  So, to always return the subset of data under `settings` in this scenario we can acheieve this by using the following filter in the lookup

{% highlight ruby %}
lookup :default do
  ...
  output_filter :dig, [ 'document', 'settings' ]
{% endhighlight %}

With this filter in place, the returned data in the above example would now be;

{% highlight json %}
{ "foo": "bar" }
{% endhighlight %}

See the _Data Digging_ section of the [HTTP datasource documentation](/datasources/http) for a more real world example of using the dig output filter

