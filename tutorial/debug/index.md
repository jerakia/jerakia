---
layout: default
---

# Quick start Tutorial

## Debugging jerakia
### Permanent debugging
To enable debugging you should add the following to your `jerakia.yaml` config file:
{% highlight console %}
---
...
loglevel: debug
{% endhighlight %}

The different available log levels are: `info, verbose` and `debug` in increasing order of verbosity.

By default jerakia will debug to: `/var/log/jerakia.log`

### Temporary debugging
You can temporarily enable debugging by passing `D` or `--debug` to the jerakia command. For more information see `jerakia help lookup`
