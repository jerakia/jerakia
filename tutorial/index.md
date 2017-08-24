---
layout: default
---

# Quick start Tutorial

This tutorial is intended as a quick guide to get set up and familar with Jerakia.

## 1) Installation

First we need to install Jerakia

To install the latest stable version

### Using a gem

{% highlight none %}
% gem install jerakia
{% endhighlight %}

### Alternative methods

You can also install Jerakia using system packages, see [Installing Jerakia](/basics/installing)


## 2) Configuration

Jerakia reads it's initial configuration from `/etc/jerakia/jerakia.yaml` by default.  At the very minimal we need to confgure the loglevel information and the locations of the logfile, policy directory and plugin directory.

Note: If you have installed Jerakia from the system packages, then a default configuration file will already exist.

{% highlight none %}
$ mkdir /etc/jerakia
$ vim /etc/jerakia/jerakia.yaml 
{% endhighlight %}

  

{% highlight yaml %}
---
policydir: /etc/jerakia/policy.d
plugindir: /var/lib/jerakia/plugins
loglevel: info
logfile: /var/log/jerakia/jerakia.log
{% endhighlight %}



## 3) Create a policy

Jerakia policies are containers for lookups.  When a lookup is invoked against Jerakia it can select a policy to use, by default, if no policy name is given then Jerakia will look for a policy called `default`

Policy files live within the directory defined in `policydir` in `jerakia.yaml`, so let's create an empty policy.  Note that if you installed Jerakia from the system packages, a default policy file should already have been created for you.  This tutorial walks you through writing one form scratch.

{% highlight none %}
$ mkdir /etc/jerakia/policy.d
$ vim /etc/jerakia/policy.d/default.rb
{% endhighlight %}

  

{% highlight ruby %}
policy :default do

end
{% endhighlight %}


## 4) Create a lookup

Jerakia policies contain lookups that run in order.

A lookup must contain, at the very least, a name and a datasource to use for the lookup. The current datasources that ship with Jerakia are  `file` and `http`. The file datasource takes several options, including format and searchpath to define how lookups should be processed. Within the lookup we have access to `scope[]` which contains all the information we need to determine what data should be returned. In Puppetspeak, the scope contains all facts and top-level variables passed from the agent 

We will start by using the `file` datasource, You can read more about the options available on the [File datasource documentation](/datasources/file)


{% highlight none %}
$ vim /etc/jerakia/policy.d/default.rb
{% endhighlight %}


Inside the policy block that we created earlier, we will now add our first lookup called `:main`.
  

{% highlight ruby %}
policy :default do

  lookup :main do
    datasource :file, {
      :format => :yaml,
      :docroot => "/var/lib/jerakia/data",
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



## 5) Add some data

Using the `file` datasource as configured earlier we can add our data to YAML files under the directory specified in `:docroot`, which we set to `/var/lib/jerakia/data`

It's recommended that you read [Jerakia Lookup Basics](/basics/lookups) to understand the structure and behaviour of a Jerakia lookup

### Understanding the file datasource

When using the `file` datasource, the `:searchpath` is evaluated to determine which files to scan and elements of the scope object can be interpolated into the file paths.  By default, Jerakia will search for the key in a filename corresponding to the namespace.  So, lets review our lookup object from earlier, it has the following settings configured...

{% highlight none %}
:format => :yaml,
:docroot => "/var/lib/jerakia/data",
:searchpath => [
  "hostname/#{scope[:fqdn]}",
  "environment/#{scope[:environment]}",
  "common"
 ]
{% endhighlight %}

If our scope contains the following

{% highlight none %}
"environment" = "development",
"fqdn"        = "host011.example.com"
{% endhighlight %}

Then when we search for the key `port` in the `apache` namespace (eg: apache::port) then Jerakia will scan the following files until it encounters the key `port:`


{% highlight none %}
/var/lib/jerakia/data/hostname/host011.example.com/apache.yaml
/var/lib/jerakia/data/environment/development/apache.yaml
/var/lib/jerakia/data/common/apache.yaml
{% endhighlight %}

The astute among you might have noticed that the search is done in a `common` directory rather than `common.yaml` as you would expect with hiera. To understand why that is the case read [File datasource](/datasources/file), to explain the functioning and differences between hiera and jerakia. To get the above debug output yourself read the [Debug Guide](/tutorial/debug)

## 6) Add data to the searchpath

Let's start off by adding the port value to our searchpath

{% highlight none %}
$ mkdir -p /var/lib/jerakia/data//common
$ vim /var/lib/jerakia/data/common/apache.yaml
{% endhighlight %}

{% highlight yaml %}
---
port: 8080
{% endhighlight %}


## 7) Running the `jerakia` command

The `jerakia` command takes a subcommand as the first attribute, for further information use `jerakia help`

### Getting help

{% highlight none %}
% jerakia help
{% endhighlight %}

{% highlight none %}
% jerakia help lookup
{% endhighlight %}

### Looking up data

To look up the data that we added earlier we can use the following command:

{% highlight none %}
% jerakia lookup port --namespace apache 
{% endhighlight %}

_Expected output_
{% highlight none %}
"8080"
{% endhighlight %}

To specify metadata like `puppet facter` data, you can run the command in the following form:
{% highlight none %}
jerakia lookup port --namespace apache --metadata environment:development fqdn:host011.example.com
{% endhighlight %}


## 8) Overriding data

### Populate the data in the hierarchy

Now let's provide some different data further up in our hierarchy, for example, we shall override `port` to be `8099` in our dev environment.

{% highlight none %}
$ mkdir -p /var/lib/jerakia/data/environment/dev
$ vim /var/lib/jerakia/data/environment/dev/apache.yaml
{% endhighlight %}

{% highlight yaml %}
---
port: 8099
{% endhighlight %}

### Query from the command line

If we run the same query command as before, we expect to get the same output

{% highlight none %}
$ jerakia lookup port --namespace apache
{% endhighlight %}
{% highlight none %}
"8080"
{% endhighlight %}

Remember that the `searchpath` gets evaluated from the scope, and since we haven't provided any scope data there is nothing to match.  Let's repeat this lookup by providing some scope data, in this case, ensuring that the environment is `dev`


{% highlight none %}
$ jerakia lookup port --namespace apache --metadata environment:dev
{% endhighlight %}
{% highlight none %}
"8099"
{% endhighlight %}


