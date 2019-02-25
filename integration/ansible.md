---
layout: default
---


## Integrating with Ansible

To integrate with Ansible, please see [the Ansible lookup plugin](http://github.com/jerakia/ansible-jerakia)

### Description

This plugin provides an interface between Ansible and Jerakia by way of a [lookup plugin](http://docs.ansible.com/ansible/latest/playbooks_lookups.html).  Further plugin types are being investigated.

A hierarchical lookup is made by applying a _scope_ against a hierarchy of lookup paths.  A scope is simply information about the requestor, in this case the Ansible node, that it used in determining what data to return.  A scope could consist of anything, typical things would be the hostname, environment and location of the node.  Using the scope provided in the lookup, Jerakia will run through a hierarchy and return the relevant value.

For the examples in the next section, we assume that Jerakia Server is installed and running on it's default port on the local machine and that we have the following default policy configured in Jerakia

{% highlight ruby %}
# /etc/jerakia/policy.d/default.rb

policy :default do
  lookup :default do
    datasource :file, {
      :format => :yaml,
      :docroot => "/var/lib/jerakia/data",
      :searchpath => [
        "node/#{scope[:hostname]}",
        "environment/#{scope[:environment]}",
        "operating_system/#{scope[:osfamily]}",
        "common"
      ]
    }
  end
end
{% endhighlight %}

See [the official documentation](http://jerakia.io/basics/lookups/) for more information about Jerakia policies and lookups

### Configuration


Once this plugin is installed, it can be used in Ansible playbooks by placing a `jerakia.yaml` file in the directory where your playbook is located.  `jerakia.yaml` must contain an [authentication token](http://jerakia.io/server/tokens) to use to connect to Jerakia Server.  We can also use the `scope` hash to map Ansible variables (facts) to the scope values used by the Jerakia policy above, eg:


{% highlight yaml %}
# ./jerakia.yaml

token: ansible:52cbf789c7837f9a4aef0d259c00d131f0f2a47894519c273c64a608de1382cba4221447752e9ac2
scope:
  hostname: ansible_nodename
  environment: environment
  osfamily: ansible_os_family
{% endhighlight %}

Note that the scope keys in this example are the scope values used in the Jerakia policy, mapped to values which are Ansible variables (facts) for that request.

Supported configuration parameters of `jerakia.yaml` are:

* `token`: The Jerakia token to use to authenticate against Jerakia server, mandatory.
* `scope`: A hash containing the scope to use for the request, the values will be resolved as Ansible facts
* `protocol`: The URL protocol to use, default `http`
* `host`: Hostname of the Jerakia Server, default `localhost`
* `port`: Jerakia port to connect to, default `9843`
* `version`: Jerakia API version to use, default `1`
* `policy`: Jerakia policy to use for the lookups, default `default`


### Usage

Once configured with a jerakia.yaml, you can call the Jerakia lookup plugin directly from your playbooks using the `lookup` method.  The first argument is always the name of the plugin, `jerakia`, and the following arguments contain the namespace and key to lookup, which is formatted as `<namespace>/<key>`

{% highlight yaml %}
{% raw %}
- hosts: all
  tasks:
    - debug: msg=" {{ lookup('jerakia',  'apache/port') }}"
{% endraw %}
{% endhighlight %}

In the above example, if we assume the value of `ansible_nodename` is `foo.enviatics.com`, `environment` is `dev` and `ansible_os_family` is `RedHat` then with the policy we have declared, this will cause Jerakia to look up the key `port` in the namespace `apache`, it will follow the following hierarchy of files looking for the key `port` and return the first value it finds:

* `/var/lib/jerakia/data/node/foo.enviatics.com/apache.yaml`
* `/var/lib/jerakia/data/environment/dev/apache.yaml`
* `/var/lib/jerakia/data/operating_system/RedHat/apache.yaml`
* `/var/lib/jerakia/data/common/apache.yaml`

So we would be able to define a default value for the Apache port in `common/apache.yaml` but then have the ability to override this value based on a specific node, environment or operating system type.  Note that the structure of the hierarchy here is purely an example, and is entirely configurable to suit your specific environment and needs.


