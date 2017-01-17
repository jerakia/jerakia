---
layout: default
---


# Installing Jerakia

## Puppet module `crayfishx/jerakia`

Installing Jerakia with Puppet is the easiest way to get up and running quckly.

{% highlight none %}
$ puppet module install crayfishx/jerakia
{% endhighlight %}

See the [Puppet Forge page](https://forge.puppetlabs.com/crayfishx/jerakia) for more information configuring Jerakia using Puppet

## Install using Rubygems

Jerakia is available as a rubygem and can be installed with

{% highlight none %}
$ gem install jerakia
{% endhighlight %}

After installing the gem, proceed to [configure Jerakia](/basics/configure)

## Install using All-in-one (AIO) system packages (DEB/RPM)

Jerakia 1.2 also ships as a completely self contained system package available on Debian, Ubuntu and Redhat/CentOS based systems.  This is the recommended installation method for users wanting to run Jerakia Server and connect to Jerakia from other tools using the API.  We use [Packager.io](https://packager.io/gh/crayfishx/jerakia) for automated package building and repo hosting.  Because the AIO package ships as a completely self contained unit (including all the Ruby dependencies) you cannot integrate with Puppet using the traditional data_binding_terminus or Hiera backend that shipped with 1.1.  In order to continue using these you will also need to install the jerakia rubygem into your Puppet MRI ruby and Puppetserver jRuby.  Alternatively you can use the `jerakia-puppetutils` gem which uses the Jerakia client libraries to integrate with Jerakia Server over the API.  Please see the [Integration with Puppet guide](/integration/puppet) for a full explanation of Puppet integration options.

There are two repositories available,  `testing` contains experimental and pre-releases and should never be used in production, these are for people wishing to test the latest features of Jerakia before they are released.  The `stable` repo contains official releases.



