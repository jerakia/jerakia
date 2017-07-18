---
layout: default
---


# Integrating Jerakia with Puppet

## Introduction

Jerakia can be integrated with Puppet using a Hiera 5 data provider function that is available as part of the [crayfishx/jerakia](https://forge.puppet.com/crayfishx/jerakia) Puppet module.

If you are running older versions of Puppet please see the [Legacy Puppet Integration](/integration/puppet_legacy) documentation

## Installing the module

You first need to install the Puppet module to your Puppet master in order to make the data provider function available to Puppet

{% highlight none %}
# puppet module install crayfishx/jerakia
{% endhighlight %}

Next you will need to [create a token](/server/tokens) that Hiera can use to authenticate it with Jerakia Server

{% highlight none %}
# jerakia token create puppet

puppet:ac2a313db95bf5d034732d9c8b202ed61b0c369fffe61cd3bdce7642df9bf8602094d01fc35c82a5
{% endhighlight %}

## Configure Hiera

To enable Jerakia in your Hiera 5 configuration it should be configured as a `lookup_key` entry.  See [The offical Puppet Documentation](https://docs.puppet.com/puppet/4.9/hiera_intro.html) for detailed information on configuring Hiera 5.   This configuration assumes you are using Jeraia as a global-layer Hiera backend - it could equally be configured at an environment or module level.

{% highlight none %}
# vim /etc/puppetlabs/puppet/hiera.yaml
{% endhighlight %}

{% highlight yaml %}
version: 5

hierarchy:
  - name: "Jerakia Server"
    lookup_key: jerakia
    options:
      token: puppet:ac2a313db95bf5d034732d9c8b202ed61b0c369fffe61cd3bdce7642df9bf8602094d01fc35c82a5
{% endhighlight %}

The `options` hash of the Hiera entry can contain options to pass to `jerakia-client`:

* `host`: Hostname or IP to connect to (default localhost)
* `port`: Port to connect to (default 9843)
* `api`: The Jerakia Server API version impemented on the server (default v1)
* `proto`: The protocol to use, `http` or `https` are supported, `http` is the default.
* `token`: The authentication token to use in the request,  if no token is specified jerakia-client will look for a `jerakia.yaml` file in `/etc/jerakia` and `~/.jerakia` for a key called `client_token`
* `interpolate`:  Enable Hiera/Puppet side interpolation of strings formatted as %{var}. This is enabled by default and can be set to `true` or `false`.  This feature will not work if you are using the `strsub` [output filter](/outputfilters)

It also support:

* `policy` : the Jerakia policy to use for the lookup (defaults to "default")
* `scope` : A hash to send as the scope object (see below)

### Defining the scope

A Jerakia lookup contains a scope, which is a set of data that controls where data is looked up from.  An example of this can be seen in the default policy that is configured when you first install the Jerakia package;

{% highlight none %}
# vim /etc/jerakia/policy.d/default.rb
{% endhighlight %}

{% highlight ruby %}
policy :default do
  lookup :main do
    datasource :file, {
      :docroot => '/var/lib/jerakia/data',
      :searchpath => [
        "hostname/#{scope[:certname]}",
        "environment/#{scope[:environment]}",
        "common",
      ],
      :format => :yaml
    }
    output_filter :encryption
  end
end
{% endhighlight %}


Here we see the main lookup we use the scope attributes `:certname` and `:environment`.  In order for Jerakia to know what these values are, we must pass them by defining them in the `hiera.yaml` file using the `scope` option of the options hash.  So in this example, our `hiera.yaml` would look like this


{% highlight yaml %}
version: 5

hierarchy:
  - name: "Jerakia Server"
    lookup_key: jerakia
    options:
      token: puppet:ac2a313db95bf5d034732d9c8b202ed61b0c369fffe61cd3bdce7642df9bf8602094d01fc35c82a5
      scope:
        certname: %{trusted.certname}
        environment: %{environment}
{% endhighlight %}

