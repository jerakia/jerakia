---
layout: minimal
---

# Basics

## Understanding Jerakia lookups

There are three important things that are contained within a Jerakia lookup, these are ;

#### The lookup _key_
The key is the item that we are looking up and contains the value

#### The lookup _namespace_
In Jerakia, each key is stored within a namespace.  A namespace can itself be a hierarchy and is sent within the lookup as an array.  When using Jerakia with Puppet, the namespace is built from the Puppet class that is requesting the lookup.  Hiera users will be familar with the concept of `$port` in the `apache` class being configured in Hiera as a single key called `apache::port`.  In Jerakia, this data would be stored as the _key_ `port` in the _namespace_ `apache`.

#### The lookup _scope_
The scope is key/value information sent by the requestor and is used by the datasource to determine how to lookup the data.  Scope may contain any information such as environments, locations, names or roles of the requestor.  When using Jerakia with Puppet in it's default mode, the scope would contain all of the facts and top-level variables of the agent.

#### The datasource
Jerakia lookup always define a datasource to use for the lookup request.   Datasources are pluggable, by default Jerakia ships with _file_ and _http_.


## An example lookup

{% highlight ruby %}
lookup :main do
  datasource :file, {
    :format     => :yaml,
    :docroot    => "/var/lib/jerakia",
    :searchpath [
      "host/#{scope[:fqdn]}",
      "env/#{scope[:environment]}",
      "common"
    ]
  }
end
{% endhighlight %}

Learn more about [How to configure Jerakia lookups](/lookups)
