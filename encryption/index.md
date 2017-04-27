---
layout: default
---

# Encryption

From Jerakia 2.0.0, encryption is a built in feature.  Jerakia has several features to decrypt and encrypt data that it achieves this by implementing a pluggable encryption provider that is configurable.  When a working encryption provider is enabled and configured, you can use the [encryption output filter](/outputfilters) to automatically detect encrypted data and decrypt it on the fly when performing lookups.


## CLI Commands

The Jerakia CLI has a command called `secret` to perform encryption tasks on the command line.  Until a provider is configured, there will be no sub commands available;

{% highlight none %}
[root@puppet functions]# jerakia help secret
Commands:
  jerakia secret help [COMMAND]  # Describe subcommands or one specific subcommand
{% endhighlight %}

To enable encryption, you must specify a provider in `/etc/jerakia/jerakia.yaml`

The default provider that ships with Jerakia is `vault`

{% highlight none %}
encryption:
  provider: vault
{% endhighlight %}

Now Jerakia will load the provider and it's capabilities are advertised, so we can now see we have `encrypt` and `decrypt` commands available

{% highlight none %}
# jerakia help secret
Commands:
  jerakia secret decrypt <encrypted value>  # Decrypt an encrypted value
  jerakia secret encrypt <string>           # Encrypt a plain text string
  jerakia secret help [COMMAND]             # Describe subcommands or one specific subcommand
{% endhighlight %}

In order to make use of this provider, you must [configure the Vault provider](/encryption/providers/vault).   
