Getting started tutorial using Jacaranda and Puppet
==============================

# About #

This is a *very quick*start guide for users already familiar with Puppet and Hiera who want to dive right in....

Note - the following is tested against Puppet 3.x, testing on Puppet 4 is ongoing

# Installation #

Jacaranda is installed from a rubygem, simply;

`gem install jacaranda`

# Configuration #

## Jacaranda configuration file ##

The first step is to create a basic configuration file for Jacaranda to tell it where to load policies, log data...etc

    # mkdir /etc/jacaranda
    # vim /etc/jacaranda/jacaranda.yml

A basic configuration looks like:

    ---
    policydir: /etc/jacaranda/policy.d
    logfile: /var/log/jacaranda.log
    loglevel: info

If you are going to use the encryption output filter provided by hiera-eyaml to enable you to use encrypted strings in your data, you can provide the keys here

    eyaml:
      private_key: /path/to/my/privkey.pem
      public_key: /path/to/my/publickey.pem

# Create your default policy #

## The policy file ##

All jacaranda requests are processed using a lookup policy.  Policy filenames should correspond to the name of the policy and are loaded from the `policydir` directive in jacaranda.yml.  If you don't specify a policy name in the lookup request then the name _default_ is used.  So let's create that now.

    # mkdir /etc/jacaranda/policy.d
    # vim /etc/jacaranda/policy.d/default.rb

Jacaranda policies are written in ruby DSL, therefore you a free to use any ruby you wish.  A Jacaranda policy is defined as a block.

    policy :default do
    
    end

## Lookups ##

Jacaranda policies are containers for lookups, which are performed in order.  A lookup contains a data source that should be used for the data lookup along with any plugun functions.  A simple example using the file data source to source data from yaml files would look like;

    policy :default do

      lookup :default do
        datasource :file, {
          :format     => :yaml,
          :docroot    => "/var/lib/jacaranda",
          :searchpath => [
            "hostname/#{scope[:fqdn]}",
            "environment/#{scope[:environment]}",
            "common",
           ],
        }
      end

    end
 


# Add data to Jacaranda #

## Data files ##

Using the YAML [file datasource](datasources/file.md), we'll now add some configuraton data for Jacaranda to query,  first lets create the directory structure

    # cd /var/lib/jacaranda
    # mkdir -p common hostname/fake.server.com environment/development

Jacaranda lookups contain two important components, a _namespace_ and a _key_, by default the file backend will search for your key in a file corresponding to _<path>/<namespace>.yml.  So let's create that now for a fictional _servers_ key in the _ntp_ namespace

    # vim /var/lib/jacaranda/common/ntp.yml

In this document we put our configuration for the _ntp_ namespace

    ---
    servers:
      - ntp0.fake.com
      - ntp1.fake.com

## Query Jacaranda from the command line ##

Using the key and the namespace we can now query this data directly from Jacaranda

    # jacaranda -k servers -n ntp
    ["ntp0.fake.com","ntp1.fake.com"]

## Hierarical overrides ##

Note the hierarchy that we have defined in our lookups. The scope is a bunch of key/value metadata that is sent with the request.  In Puppet terms, these would be facts and top-level variables.  In our fictional environment we are going to override the ntp servers for everything in the dev environment by creating a new data file at the environment level.

    # mkdir /var/lib/jacaranda/environment/development
    # vim /var/lib/jacaranda/environment/development/ntp.yml

And put in different server names 

    ---
    servers:
      - ntp0.devbox.com
      - ntp1.devbox.com

## Query using scope ##

We can simulate the scope of the lookup request on the command line by passing key:val pairs after the arguments

    # jacaranda -k servers -n ntp environment:production
    ["ntp0.fake.com","ntp1.fake.com"]
    
By running against production, we have the values returned from common as there is no production environment defined, but if we now run the same lookup but with development environment in the scope, we get different results

    # jacaranda -k servers -n ntp environment:development
    ["ntp0.devbox.com","ntp1.devbox.com"]

# Integration with Puppet #

There are a few options to integrate Jacaranda with Puppet.


## As a hiera backend ##

Hiera can be enabled very simply by simply adding it as a backend to hiera

    # vim /etc/hiera.yaml

Jacaranda can be used in place of, or addition to, other hiera backends.

    ---
    :backends:
      - jacaranda

We can now query the same data using Hiera

    # hiera ntp::servers environment=production
    ["ntp0.fake.com","ntp1.fake.com"]
     
    # hiera ntp::servers environment=development
    ["ntp0.devbox.com","ntp1.devbox.com"]

Note that using the Hiera backend, a query of foo::bar will send a lookup request to Jacaranda for the key _bar_ with the namespace _foo_

## The Puppet data binding terminus ##

Jacaranda supports a puppet data binding terminus for direct integration, this is the preferred method of using Jacaranda from Puppet although we still advise having the hiera backend to support any modules that use hiera() function calls directly.  Using the data binding terminus however will route all data mapping requests from parametersed classes directly to Jacaranda.

This can be configured in `/etc/puppet/puppet.conf` under the `[master]` section

      [master]
        data_terminus = jacaranda

Let's write a small module to test this....

    # mkdir -p /etc/puppet/modules/ntp/manifests
    # vim /etc/puppet/modules/ntp/manifests/init.pp

A simple class to perform a data mapping lookup.

    class ntp (
      $servers = 'unknown',
    ) {
      notify { $servers: }
    }

Now we should be able to use Jacaranda transparently from Puppet

    # puppet -e 'include ntp'
    Notice: /Stage[main]/Ntp/Notify[ntp0.fake.com]/message: defined 'message' as 'ntp0.fake.com'
    Notice: /Stage[main]/Ntp/Notify[ntp1.fake.com]/message: defined 'message' as 'ntp1.fake.com'


# Existing Hiera compatibility #

You would have noted by now that Jacaranda does things slightly differently from Hiera, notably the location of files using the namespace as the filename.  Whereas Jacaranda searches for _key_ in _<path>/<namespace>.yml  Hiera will search for _<namespace>::<key>_ in _<path>.yaml_  (note the file extentions).  It is however possible to use Jacaranda on top of your existing Hiera file structure in order to test drive it without modifying your data by using the hiera_compat plugin that ships with Jacaranda.

An example Hiera herarchy would like:

    # cat /var/lib/hiera/common.yaml
    ---
    apache::port: 80
    ntp::servers:
      - ntp0.fake.com
      - ntp1.fake.com
 
The corresponding hiera.yaml file might contain

    ---
    :backends:
      - yaml

    :yaml:
      :datadir: /var/lib/hiera

    :hierarchy:
      - "hostname/%{hostname}"
      - "environment/%{environment}"
      - "common"

Using the hiera_compat plugin, the jacaranda lookup is rewritten to mesh the lookup key to _<namespace>::<key>_ and drop the namespace from the request, meaning Jacaranda will search for _<namespace>::<key>_ in _<path>.yaml, just like Hiera.   Here is an example of a Jacaranda policy that simulates the same Hiera config

    policy :default do

      policy :hiera do
        datasource :file, {
          :format     => :yaml,
          :extension  => 'yaml', # Remember what we said about extensions?
          :searchpath => [
            "hostname/#{scope[:hostname]}",
            "environment/#{scope[:environment]}",
            "common",
          ],
        }
        hiera_compat
      end
    end


# Further reading #

Some other examples of Jacaranda policies and lookups with various plugins [can be found here](policy.md) with further documentation appearing in the docs/ section of the site.

We are trying to document this as fast as we write it - please bear with us.
