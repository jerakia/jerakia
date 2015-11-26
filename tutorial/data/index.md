---
layout: minimal
---

# Quick start Tutorial

Using the `file` datasource as configured earlier we can add our data to YAML files under the directory specified in `:docroot`, which we set to `/var/lib/jerakia`

It's recommended that you read [Jerakia Lookup Basics](/basics/lookups) to understand the structure and behaviour of a Jerakia lookup

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

[Read more about the File datasource](/datasources/file)

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
