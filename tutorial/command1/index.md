---
layout: minimal
---

# Quick start Tutorial

## Running the `jerakia` command

The `jerakia` command takes a subcommand as the first attribute, for further information use `jerakia help`

### Getting help

{% highlight console %}
% jerakia help
{% endhighlight %}

{% highlight console %}
% jerakia help lookup
{% endhighlight %}

### Looking up data

To look up the data that we added earlier we can use the following command:

{% highlight console %}
% jerakia lookup port --namespace apache 
{% endhighlight %}

_Expected output_
{% highlight console %}
"8080"
{% endhighlight %}

To specify `facter` or other metadata you can run the command in the following form:
{% highlight console %}
jerakia lookup port --namespace apache --metadata environment:development fqdn:host011.example.com
{% endhighlight %}


Next: [Overriding data](/tutorial/override)
