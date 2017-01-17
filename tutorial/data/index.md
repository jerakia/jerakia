---
layout: default
---

# Quick start Tutorial

Using the `file` datasource as configured earlier we can add our data to YAML files under the directory specified in `:docroot`, which we set to `/var/lib/jerakia`

It's recommended that you read [Jerakia Lookup Basics](/basics/lookups) to understand the structure and behaviour of a Jerakia lookup

## Understanding the file datasource

When using the `file` datasource, the `:searchpath` is evaluated to determine which files to scan and elements of the scope object can be interpolated into the file paths.  By default, Jerakia will search for the key in a filename corresponding to the namespace.  So, lets review our lookup object from earlier, it has the following settings configured...

{% highlight none %}
:format => :yaml,
:docroot => "/var/lib/jerakia",
:searchpath => [
  "hostname/#{scope[:fqdn]}",
  "environment/#{scope[:environment]}",
  "common"
 ]
{% endhighlight %}

If our scope contains the following

{% highlight none %}
"environment" => "development",
"fqdn"        => "host011.example.com"
{% endhighlight %}

Then when we search for the key `port` in the `apache` namespace (eg: apache::port) then Jerakia will scan the following files until it encounters the key `port:`


{% highlight none %}
/var/lib/jerakia/hostname/host011.example.com/apache.yaml
/var/lib/jerakia/environment/development/apache.yaml
/var/lib/jerakia/common/apache.yaml
{% endhighlight %}

The astute among you might have noticed that the search is done in a `common` directory rather than `common.yaml` as you would expect with hiera. To understand why that is the case read [File datasource](/datasources/file), to explain the functioning and differences between hiera and jerakia. To get the above debug output yourself read the [Debug Guide](/tutorial/debug)

## Add data to the searchpath

Let's start off by adding the port value to our searchpath

{% highlight none %}
$ mkdir -p /var/lib/jerakia/common
$ vim /var/lib/jerakia/common/apache.yaml
{% endhighlight %}

{% highlight yaml %}
---
port: 8080
{% endhighlight %}


Next: [Running Jerakia from the command line](/tutorial/command1)
