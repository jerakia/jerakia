---
layout: minimal
---


# Configuring Jerakia

## `jerakia.yaml`

Jerakia has a small core configuration in `jerakia.yaml`.  The default location for the configuration file is `/etc/jerakia`


### Example:

{% highlight ruby %}

---
policydir: /etc/jerakia/policy.d
plugindir: /etc/jerakia/lib
loglevel: info
logfile: /var/log/jerakia.log

{% endhighlight %}


### Configuration directives

`jerakia.yaml` can be configured with the following configuration directives.

#### `policydir`
The location of Jerakia policy files.  Policies should be named `<name>.rb` and be installed into this directory

#### `plugindir`
The location where Jerakia will search for lookup plugins.  Plugins will be searched in `jerakia/lookup/plugin` relative to this directory

#### `loglevel`
The log level, can be `info` or `debug`

#### `logfile`
The logfile Jerakia uses to write to

### Optional configuration directives

#### `eyaml`
If you are using the encryption response filter you need to configure Jerakia with the locations of your SSL keys for eyaml. This option is a hash containing `private_key` and `public_key`.  Eg:
{% highlight yaml %}
eyaml:
  public_key: /etc/jerakia/secure/public_key.pem
  private_key: /etc/jerakia/secure/private_key.pem
{% endhighlight %}


