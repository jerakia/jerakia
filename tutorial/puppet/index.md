---
layout: default
---

# Quick start Tutorial

## Integration with Puppet

### As a Hiera backend

Jerakia can be configured as a Hiera backend

{% highlight none %}
$ vim /etc/puppet/hiera.yaml
{% endhighlight %}

{% highlight yaml %}
---
:backends: [ 'jerakia' ]
{% endhighlight %}

or add it as an additional data source:

### As a Puppet data binding terminus
{% highlight yaml %}
---
:backends:
  - jerakia
{% endhighlight %}

If you are migrating an existing, or unknown code base we would recommend you keep Hiera configured as a backend to catch any lookups that are made with the `hiera`, `hiera_hash` or `hiera_array` functions.  But for all other lookups you can route them straight to Puppet by bypassing Hiera altogether and using Jerakia as a data binding terminus



{% highlight none %}
$ vim /etc/puppet/puppet.conf
{% endhighlight %}

{% highlight none %}
[master]
  ...
  data_binding_terminus = jerakia
{% endhighlight %}

next: [Debugging](/tutorial/debug)
