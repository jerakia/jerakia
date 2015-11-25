---
layout: minimal
---

# Quick start Tutorial

## Understanding Jerakia lookups

Using the `file` datasource as configured earlier we can add our data to YAML files under the directory specified in `:docroot`, which we set to `/var/lib/jerakia`

There are three important things that are contained within a Jerakia lookup, these are ;

#### The lookup _key_
The key is the item that we are looking up and contains the value

#### The lookup _namespace_
In Jerakia, each key is stored within a namespace.  A namespace can itself be a hierarchy and is sent within the lookup as an array.  When using Jerakia with Puppet, the namespace is built from the Puppet class that is requesting the lookup.  Hiera users will be familar with the concept of `$port` in the `apache` class being configured in Hiera as a single key called `apache::port`.  In Jerakia, this data would be stored as the _key_ `port` in the _namespace_ `apache`.

#### The lookup _scope_
The scope is key/value information sent by the requestor and is used by the datasource to determine how to lookup the data.  Scope may contain any information such as environments, locations, names or roles of the requestor.  When using Jerakia with Puppet in it's default mode, the scope would contain all of the facts and top-level variables of the agent.

## Understanding the file datasource

When using the `file` datasource, the `:searchpath` is evaluated to determine which files to scan and elements of the scope object can be interpolated into the file paths.  By default, Jerakia will search for the key in a filename corresponding to the namespace.  So, lets review our lookup object from earlier, it has the following settings configured...

{% highlight console %}
:format => :yaml,
:docroot => "/var/lib/jerakia",
:searchpath => [
  "hostname/#{scope[:fqdn}",
  "environment/#{scope[:environment]}",
  "common"
 ]
{% endhighlight %}

If our scope contains the following

{% highlight console %}
"environment" => "development",
"fqdn"        => "host011.example.com"
{% endhighlight %}

Then when we search for the key `port` in the `apache` namespace (eg: apache::port) then Jerakia will scan the following files until it encounters the key `port:`


{% highlight console %}
/var/lib/jerakia/hostname/host011.example.com/apache.yaml
/var/lib/jerakia/environment/development/apache.yaml
/var/lib/jerakia/environment/common/apache.yaml
{% endhighlight %}

## Add data to the searchpath

Let's start off by adding the port value to our searchpath

{% highlight console %}
$ mkdir -p /var/lib/jerakia/common
$ vim /var/lib/jerakia/common/apache.yaml
{% endhighlight %}

{% highlight yaml %}
---
port: 8080
{% endhighlight %}


Next: [Running Jerakia from the command line](/tutorial/command1)
