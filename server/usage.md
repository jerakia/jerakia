---
layout: default
---

# Jerakia Server

## Usage

Jerakia server can be started from the Jerakia CLI utility using the `server` subcommand

{% highlight none %}
# jerakia server &
{% endhighlight %}

If you installed Jerakia using the AIO system package [see installation docs](/basics/install/) on a systemd based platform, you can start Jerakia server using the systemd unit script.

{% highlight none %}
# systemctl start jerakia
{% endhighlight %}

By default Jerakia server will bind to `127.0.0.1` on port `9843`

## Configuration

Jerakia Server configuration defaults can be overwritten in the `jerakia.yaml` configuration file by adding a hash called `server`, eg:

{% highlight yaml %}
server:
  port: 9991
{% endhighlight %}

It supports the following configuration options

* `bind` : The IP address to bind to. This should always be `127.0.0.1` in a production environment, if you wish to expose the API across the network you should use a reverse proxy such as nginx and use HTTPS
* `port` : The port for Jerakia Server to use, the default is `9843`
* `token_ttl` : The length of time (in seconds) to cache tokens in memory before refreshing from the database, setting this option too low can impact performance, the default is 300 seconds.

