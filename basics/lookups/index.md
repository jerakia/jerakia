---
layout: default
---

# Lookups

## Hierarchical Data Lookups

Hierarchical data lookups solve the problem of having to wrap logic around your data and enable you to store it in a more pure form.  In Jerakia there are two factors used to determine the returned value of a lookup. The _hierarchy_ and the _scope_.

### The Hierarchy

Consider infrastructure data, typically data related to an infrastructure will vary between different environments, or locations, so must either be recorded separately for each diferenciation or centralized and wrapped in logic.  Often we will want to define defaults for things that may ore may not be overridden in particular situations.  For this we use a *hierarchy*.  A hierarchy in Jerakia is entirely arbirarty and can have as many levels as you require to model the data effectivly.  Consider the following simple hierarchy representing infrastructure;

![A simple hierarchy](/images/hierarchy.png){: .center-image }

When performing a lookup for a key using this hierarchy, first we will check to see if there is any host-specific data that matches the key being looked up.  If no data is found, then we fall down to the next level to check if there is any data specific to the environment, if still there is no data then we fall down to location-specific data and then finally we see if there is any data in _all_ which is the level where we would store system wide defaults.   This gives you the ability to declare a key value pair in _all_ and override it just for specific environments, locations or individual hosts.


### The Scope

The scope is an essential part of the lookup process and is provided with a request for a key.  The scope contains information that determines the context of the lookup through the hierarchy.  In our above example, a scope may contain the hostname, environment and location of the requestor and this is used by the hierarchy to determine what gets looked up at each level.

### With Jerakia
 
In Jerakia we write lookups inside policies.  Policies are written in Ruby DSL which gives a high degree of flexibility in solving complex edge cases.  An example of a simple Jerakia policy to perform a lookup using the above hierarchy and the default _file_ datasource  would be;

{% highlight ruby %}
policy :default do
  lookup :main do
    datasource :file, {
      format:     :yaml,
      docroot:    '/var/lib/jerakia/data',
      searchpath: [
        "hostname/#{scope[:certname]}",
        "environment/#{scope[:environment]}",
        "location/#{scope[:location]}",
        'all',
      ]
    },
  end
end
{% endhighlight %}     

Our search hierarchy is defined in the `searchpath` parameter and it uses elements from the scope to expand an ordered list of file paths to search for data.  [Learn more about Jerakia lookups](/basics/lookups)

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

#### The output filter
Once a datasource has returned an answer, that answer is optionally passed to a configurable output filter (such as `encryption` or `strsub`) which has the ability to modify the answer before it gets sent back to the requestor.

## Summary 

![A Jerakia Lookup](/images/jerakia_flow.png){: .center-image }

Learn more about [How to configure Jerakia lookups](/lookups)
