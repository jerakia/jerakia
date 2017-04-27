---
layout: default
---

# The Vault encryption provider

## Introduction

The Vault encryption provider enables Jerakia to use the Transit Secret backend of Vault to perform encryption and decryption on the fly, essensially using Vault as an _encryption as a service_ provider.

You will first need to configure vault with the correct backend, keys, polciies and app_role in order for Jerakia to be able to successfully authenticate and use the transit endpoint.  For more in depth information on configuring Vault, see the post [Managing Puppet Secrets with Jerakia and Vault](http://www.craigdunn.org) which gives a step by step guide to preparing Vault for integration with Jerakia.

## Configuring the provider

The Vault encryption provider requires at least the following information in order to be configured

* A valid Vault token
_or both of the following_
* A valid AppRole ID (role_id)
* A valid Secret ID (secret_id)

Although using a regular token will work, it will eventually expire and require manual intervention to renew.  We recommend using a `role_id` and `secret_id` to enable Jerakia to automatically renew it's expired tokens.

The following options are accepted in the `encryption` section of `/etc/jerakia/jerakia.yaml`

* `provider` : Must be set to `vault`
* `vault_addr` : The URL to access vault (default: https://127.0.0.1:8200)
* `vault_use_ssl`: Must be set to false if you are using HTTP (default: true)
* `vault_ssl_key`: Path to the SSL key (if using SSL)
* `vault_ssl_cert`: Path to the SSL certificate (if using SSL)
* `vault_ssl_verify`: Whether or not verify the SSL connection (default true)
* `vault_token`: A regular Vault authentication token (not recommended)
* `vault_role_id`: The AppRole ID to use to connect to Vault
* `vault_secret_id`: The Secret ID that corresponds to the `vault_role_id`
* `vault_api_version`: The API version for vault (default: 1)
* `vault_keyname`: The name of the key to use for transit backend (default: jerakia)

### Example

{% highlight yaml %}
encryption:
  provider: vault
  vault_addr: http://127.0.0.1:8200
  vault_use_ssl: false
  vault_role_id: f43b0557-d485-5223-f2b2-75135391cfe5
  vault_secret_id: 8a2fa99c-7811-5e65-a74a-8ab2ba9b6389
{% endhighlight %}


### Usage 

Once configured correctly, you can encrypt and decrypt values on the command line, eg:

{% highlight none %}
# jerakia secret encrypt secretThing
vault:v1:ZDXtHprxLDnAJySOcyAnc5F2RJlIGtOnoxeJICQXUrYf9A3iOC76
{% endhighlight %}

The resulting encrypted string can be placed along side your regular data.  When [the encryption output filter](/outputfilters) is enabled in a lookup, this string will automatically be detected as encrypted and the provider will be called to decrypt it before passing the results back to the lookup requestor



