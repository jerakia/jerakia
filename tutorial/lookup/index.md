---
layout: minimal
---

# Quick start Tutorial

## Create a lookup

Jerakia policies contain lookups that run in order.

A lookup must contain, at the very least, a name and a datasource to use for the lookup. The current datasources that ship with Jerakia are  `file` and `http`. The file datasource takes several options, including format and searchpath to define how lookups should be processed. Within the lookup we have access to `scope[]` which contains all the information we need to determine what data should be returned. In Puppetspeak, the scope contains all facts and top-level variables passed from the agent 

We will start by using the `file` datasource, You can read more about the options available on the [File datasource documentation](/datasources/file)


{% highlight console %}
$ vim /etc/jerakia/policy.d/default.rb
{% endhighlight %}


Inside the policy block that we created earlier, we will now add our first lookup called `:main`.
  

{% highlight ruby %}
policy :default do

  lookup :main do
    datasource :file, {
      :format => :yaml,
      :docroot => "/var/lib/jerakia",
      :searchpath => [
        "hostname/#{scope[:fqdn]}",
        "environment/#{scope[:environment]}",
        "common"
      ]
    }
  end

end
{% endhighlight %}

Here we have described the `:main` lookup to use the datasource `file`.  `:format` refers to which data format to expect files to use, Jerakia can support a number of format handlers that plug into the file datasource, in this case we are using the `yaml` handler.  `:docroot` refers to where we store our data files.  The `searchpath` contains an array of locations, relative to the `:docroot` that represents a search hierarchy that will be searched in order for the lookup key  

The `scope` object contains information about the requestor that helps determine how we look up the data, in this case, we base the lookup on the `fqdn` and `environment` of the requestor.  More on scope later.


Next: [Create some data](/tutorial/data)
