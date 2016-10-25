---
layout: minimal
---

# Quick start Tutorial

## Debugging jerakia
To enable debugging you should add the following to your `jerakia.yaml` config file:
{% highlight console %}
---
...
loglevel: debug
{% endhighlight %}

The different available log levels are: `info, verbose` and `debug` in increasing order of verbosity.

By default jerakia will debug to: `/var/log/jerakia.log`
