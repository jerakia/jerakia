---
layout: default
---


# Legacy Puppet Integration ( < Puppet 4.9 )

## Introduction

There have been numerous integration points between Jerakia and Puppet and it's not always been clear exactly what method you should use.  The reason for this is primarily that Puppet themselves have going through somewhat of a state of transition when it comes to data lookups, with the arrival of Hiera 5 in Puppet 4.9 and the planned deprecation of older legacy data lookup integration points such as the `data_binding_terminus` and the eventual deprecation of the current implementation of Hiera in future releases.  These changes are happening over a long period of time to allow for users to sucessfully migrate, so in turn that means that Jerakia needs to be able to support the older (and still valid) ways of integrating external data providers and the newer methods that were introduced in Puppet 4.9 / Hiera 5.

This guide is only for integrating with Puppet installations older than 4.9 - if you are on 4.9 or above running Hiera 5, you should use the [recommended integration](/integration/puppet)

Below is a summary of the ways to integrate Jerakia with Hiera 3 / Puppet < 4.9

## The `jerakia-puppet` library

In Jerakia 2.0.0 all puppet integration points were stripped out of the core codebase.  In order to use the legacy integration methods you must install the rubygem `jerakia-puppet`

```
/opt/puppetlabs/puppet/bin/gem install jerakia-puppet
puppetserver gem install jerakia-puppet
```

This library gives you a few different options;

### Data binding terminus

A `data_binding_terminus` is ruby code that is called directly from Puppet and is used to pass lookups.   It is configured with the `data_binding_terminus` in `puppet.conf`.  Historically most users have only used `none` or `hiera` for this option.

#### Native binding

Jerakia-Puppet ships with a terminus called `jerakia` that is a drop-in replacement for the current `hiera` one and can be enabled by configuring the following in `puppet.conf`

{% highlight bash %}
[main]
data_binding_terminus = jerakia
{% endhighlight %}

In order for this terminus to work, the Jerakia ruby libraries must be loadable from Puppet.  If you have installed Jerakia from the AIO system packages, you will need to also add the gem to Puppets' ruby in order to use this implementation.  (note this will not install in jruby)

#### REST Client binding (experimental)

If you have installed Jerakia 1.2+ from the AIO system package, and do not want to also maintain a separate copy of Jerakia core as a rubygem in Puppet, or if you wish to run Puppet and Jerakia on separate servers, there is a new (currently experimental) data binding terminus called `jerakiaserver` that ships in an external rubygem, `jerakia-puppet`, that uses the `jerakia-client` ruby libraries to integrate with Jerakia Server over HTTP REST.

It can be configured in `puppet.conf` with

{% highlight bash %}
data_binding_terminus = jerakiaserver
{% endhighlight %}

Note that the `data_binding_terminus` feature of Puppet is being deprecated and is expected to be removed in Puppet 6.0

### Hiera 3.x backend (Native Ruby)

Jerakia ships with a Hiera 3.x backend that loads Jerakia directly and passes lookup requests. It has slightly slower performance than using the data binding terminus but otherwise operates transparently.  To enable the Jerakia Hiera backend you need to have the Jerakia gem loadable from Puppets' ruby path.  It can be configured simply with;

{% highlight yaml %}
---
:backends:
  - jerakia
{% endhighlight %}

Optional configuration can be given as a hash named `:jerakia`....

{% highlight yaml %}
:jerakia:
  :config: /etc/puppetlabs/code/jerakia.yaml
{% endhighlight %}

See [configuring jerakia](/basics/configure) for acceptable configuration parameters.

### Hiera 3.x backebd (REST API)

There is also a Hiera 3.x backend for performing lookups using the `jerakia-client` library to Jerakia over the HTTP API.  The backend can be configured with the options to pass to `jerakia-client`

Eg:
{% highlight yaml %}
:backends:
  - jerakiaserver

:jerakia
  token: puppet:ac2a313db95bf5d034732d9c8b202ed61b0c369fffe61cd3bdce7642df9bf8602094d01fc35c82a5
{% endhighlight %}  


## See also
* [Jerakia client project home](https://github.com/jerakia/jerakia-client)

