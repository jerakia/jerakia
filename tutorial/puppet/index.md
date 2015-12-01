---
layout: minimal
---

# Quick start Tutorial

## Integration with Puppet

### As a Hiera backend

Jerakia can be configured as a Hiera backend

{% highlight console %}
$ vim /etc/puppet/hiera.yaml
{% endhighlight %}

{% highlight yaml %}
---
:backends: [ 'jerakia' ]
{% endhighlight %}

### As a Puppet data binding terminus

If you are migrating an existing, or unknown code base we would recommend you keep Hiera configured as a backend to catch any lookups that are made with the `hiera`, `hiera_hash` or `hiera_array` functions.  But for all other lookups you can route them straight to Puppet by bypassing Hiera altogether and using Jerakia as a data binding terminus



{% highlight console %}
$ vim /etc/puppet/puppet.conf
{% endhighlight %}

{% highlight console %}
[master]
  ...
  data_binding_terminus = jerakia
{% endhighlight %}
