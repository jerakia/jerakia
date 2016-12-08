---
layout: default
---

# Quick start Tutorial

## Overriding data

### Populate the data in the hierarchy

Now let's provide some different data further up in our hierarchy, for example, we shall override `port` to be `8099` in our dev environment.

{% highlight console %}
$ mkdir -p /var/lib/jerakia/environment/dev
$ vim /var/lib/jerakia/environment/dev/apache.yaml
{% endhighlight %}

{% highlight yaml %}
---
port: 8099
{% endhighlight %}

### Query from the command line

If we run the same query command as before, we expect to get the same output

{% highlight console %}
$ jerakia lookup port --namespace apache
{% endhighlight %}
{% highlight console %}
"8080"
{% endhighlight %}

Remember that the `searchpath` gets evaluated from the scope, and since we haven't provided any scope data there is nothing to match.  Let's repeat this lookup by providing some scope data, in this case, ensuring that the environment is `dev`


{% highlight console %}
$ jerakia lookup port --namespace apache --metadata environment:dev
{% endhighlight %}
{% highlight console %}
"8099"
{% endhighlight %}


Next: [Integration with Puppet](/tutorial/puppet)
