---
layout: default
---

# Output Filters

## strsub

### Description

The `strsub` filter will parse the data for strings matching `%{var}` and attempt to replace the tag with the corresponding value `var` from the scope provided with the lookup.

If you are [Integrating with Puppet](/integration/puppet) using the Hiera 5 data provider in [crayfishx/jerakia](https://forge.puppet.com/crayfishx/jerakia) 1.2.0 or higher then you can do interpolation natively using the Hiera backend (enabled by default).  This output filter should not be used in that case.

If the datasource returns structured data (a hash or an array) this filter will walk through the structure and perform the string substution on each individual value

Eg:

{% highlight yaml %}
---
vhosts:
  default:
    port: 80
    hostname: "www.%{environment}.corp.com"
{% endhighlight %}


### Usage

{% highlight ruby %}
    output_filter :strsub
{% endhighlight %}
