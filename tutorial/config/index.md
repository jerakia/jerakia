---
layout: default
---

# Quick start Tutorial

## Configuration

Jerakia reads it's initial configuration from `/etc/jerakia/jerakia.yaml` by default.  At the very minimal we need to confgure the loglevel information and the locations of the logfile, policy directory and plugin directory.

If you have installed Jerakia from the system packages, then a default configuration file will already exist.

{% highlight none %}
$ mkdir /etc/jerakia
$ vim /etc/jerakia/jerakia.yaml 
{% endhighlight %}

  

{% highlight yaml %}

---
policydir: /etc/jerakia/policy.d
plugindir: /var/lib/jerakia/plugins
loglevel: info
logfile: /var/log/jerakia/jerakia.log

{% endhighlight %}


Next: [Create a Policy](/tutorial/policy)
