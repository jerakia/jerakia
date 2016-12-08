---
layout: default
---

# Datasources

## Introduction

Datasources define where and how our data is looked up.  A datasource can interact with a variety of sources, from files, databases, REST API's and more.  Jerakia will pass the lookup request and any options off to the datasource defined in the lookup.  A lookup can only specify one datasource but different lookups can implement different datasources.
## Usage

Datasources are defined in the lookup block using the `datasource` method.  The method takes the datasource name (prefixed with `:`) as the first argument, followed by a hash of options

{% highlight ruby %}
datasource :name, { :option => "value"... }
{% endhighlight %}

Jerakia ships with the [file](/datasources/file), [http](/datasources/http) and [dummy](/datasources/dummy)  datasources.  It is also easy to extend Jerakia with other data sources.

## Example

Here is an example of using the [file datasource](/datasources/file) in a fairly standard YAML search hierarchy. 

{% highlight ruby %}
datasource :file, {
  :format     => :yaml,
  :docroot    => "/var/lib/jerakia",
  :searchpath [
    "hostname/#{scope[:hostname}",
    "env/#{scope[:environment]}",
    "common"
  ]
}
{% endhighlight %}


