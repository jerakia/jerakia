---
layout: minimal
---

# Quick start Tutorial

## Configuration

Jerakia reads it's initial configuration from `/etc/jerakia/jerakia.yaml` by default.  At the very minimal we need to confgure the loglevel information and the locations of the logfile, policy directory and plugin directory.

{% highlight console %}
$ mkdir /etc/jerakia
$ vim /etc/jerakia/jerakia.yaml 
{% endhighlight %}

  

{% highlight ruby %}

---
policydir: /etc/jerakia/policy.d
plugindir: /etc/jerakia/lib
loglevel: info
logfile: /var/log/jerakia.log

{% endhighlight %}


Next: [Create a Policy](/tutorial/policy)
