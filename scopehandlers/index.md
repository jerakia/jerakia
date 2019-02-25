---
layout: default
---

# Scope Handlers

## Introduction 

When a request is processed with Jerakia it contains a scope.  A scope is a set of data key value pairs that are used to determine the behaviour of a lookup.  For example, if your lookup hierarchy contains different hierarchical levels depending on "datacenter" and "environment", the values for "datacenter" and "environment" will be read from the scope.   Where the scope data comes from is the responsibility of the scope handler.  This, like most of Jerakia, is a pluggable interface.   The default scope handler is `metadata` which simply maps whatever metadata is sent with the request object.

Scope handlers are called by sending the `scope` attribute with the lookup request and can support numerious options.

## Handlers

### Metadata

The simplest scope handler that ships with Jerakia is `metadata`, and is the default if no `scope` option is sent with the request.  This handler simplies copies the metadata sent with each request and uses that for the scope.

### PuppetDB

Jerakia 1.2 introduced the PuppetDB scope handler. When using this scope handler, Jerakia will query PuppetDB for the scope for the request.

#### Options

* `puppetdb_host`:  PuppetDB host to connect to (default: localhost)
* `puppetdb_port`: Port to use (default: 8080)
* `puppetdb_api`: API to use for PuppetDB quieres, currently only supports 4, (default: 4)
* `node`: The node name to query in PuppetDB

#### Example

{% highlight none %}
# jerakia lookup port -n apache --scope puppetdb --scope_opts puppetdb_host:puppetdb.mycorp.com,node:barny.localdomain
{% endhighlight %}


### YAML

The YAML scope handler can take a YAML file containing key value pairs and use that for the scope.

#### Options

* `file`: YAML file name to parse (default: ./jerakia_scope.yaml)

#### Example

{% highlight none %}
# jerakia lookup port -n apache --scope yaml --scope_opts file:barny.localdomain.yaml
{% endhighlight %}

### Server

There is a special scope handler called `server` which is exposed by Jerakia server.  Currently it is used by the [jerakia data binding in puppet](https://github.com/jerakia/jerakia-puppet).  It allows for the scope data to be sent ahead of time by the requestor using the Jerakia API and then subsequent lookups will read from this.  This is currently experimental.


