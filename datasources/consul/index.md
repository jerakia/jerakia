---
layout: default
---

# Datasources

## Consul datasource

The consul_kv datasource allows Jerakia to retreive values from [Hashicorp Consul](http://consul.io) using the key value store features (Consul KV)


### Global configuration options

Global configuration for consul is placed in `jerakia.yaml` under the `consul` configuration key.  The following configuration options are supported.   Jerakia uses [the Diplomat](https://github.com/WeAreFarmGeek/diplomat#custom-configuration) library to integrate with Consul KV

* `url`: HTTP URL to connect to the Consul KV API, default: http://localhost:8500
* `acl_token`: Optional ACL token to supply with the API requests
* `options`: A hash of options to provide to Faraday, see [the Diplomat documentation](https://github.com/WeAreFarmGeek/diplomat#custom-configuration) for information

#### Example:

{% highlight yaml %}
consul:
  url: http://localhost:8888
{% endhighlight %}

### Datasource Options

The following options are available when declaring the consul_kv datasource within a Jerakia lookup

* `datacenter`: A string, Optionally specify a dc (datacenter) for the lookup
* `to_hash`: Boolean, default: true.  Will consolidate the results into a hash instead of an array.
* `recursive`: Boolean, default: false. Will return the entire data structure from Consul KV rather than just the requested key
* `searchpath`: Array, default: [ '/' ].  A set of prefixes, Jerakia will iterate through each level of the searchpath appending the namespace and lookup key


### Example 

#### Add some data to Consul KV

{% highlight none %}
# consul kv put environment/development/apache/port 8080
Success! Data written to: environment/development/apache/port
# consul kv put common/apache/port 80
Success! Data written to: common/apache/port
{% endhighlight %}

#### A corresponding Jerakia policy

{% highlight ruby %}
policy :default do
  lookup :main do
    datasource :consul_kv, {
      :searchpath => [
        "environment/#{scope[:environment]}",
        "common"
      ]
    }
  end
end
{% endhighlight %}

#### Lookup

Data can now be looked up hierarchically.

{% highlight none %}
# bin/jerakia lookup port -n apache
80
# bin/jerakia lookup port -n apache --metadata environment:development
8080
{% endhighlight %}


### Lookup Key

The key that gets passed to Consul KV consists of the search prefix
