---
layout: default
---

# Jerakia Server

## Tokens

### Introduction

Jerakia uses tokens to authenticate access to the REST API for performing lookups using Jerakia Server.  Before you can use the API you must first create a valid token for the application to use when making requests, the token must be sent in the `X-Authentication` HTTP header of each request.  Jerakia Server does not maintain a session.

Jerakia tokens are managed using the `jerakia token` command.

### Creating a new token

To create a Jerakia token, issue the `jerakia token create` command with an identifier for the intended application.  Eg:

{% highlight none %}
# jerakia token create my_app
{% endhighlight %}

The output of the command will contain the token

{% highlight none %}
Copy the following token to the application, it must be sent in the Authorization header. This token cannot be retrieved later, if you have lost the token for an application you can create a new one with 'jerakia token regenerate <api id>'

my_app:ac2a313db95bf5d034732d9c8b202ed61b0c369fffe61cd3bdce7642df9bf8602094d01fc35c82a5
{% endhighlight %}

The token is stored internally in a small database, but it is not retrievable. You should copy this authentication token and configure it in your application.  If you lose an authentication token you must regenerate it with the `regenerate` option. Eg:

{% highlight none %}
# jerakia token regenerate my_app
{% endhighlight %}

This will delete the previous token and create a new one that must be copied.

If you need to automate this step, you can pass the `--quiet` option to the `create` subcommand, this will supress the explanatory output of the command and just output the token.

### Viewing tokens

You can see a summary of what tokens are in use and their status using the `jerakia token list` command.  Eg:

{% highlight none %}
# jerakia token list
API Identifier       Last Seen                    Status

my_app               2016-12-20 12:04:58          active
{% endhighlight %}

### Managing tokens

You can disable a token by using the `jerakia token disable` command.  The token will continue to be stored in the database but access to the API will be denied using this token.

{% highlight none %}
# jerakia token disable my_app
# jerakia token list
API Identifier       Last Seen                    Status

my_app               2016-12-20 12:04:58          disabled
{% endhighlight %}

You can re-enable the token using the `enable` subcommand

{% highlight none %}
# jerakia token enable my_app
{% endhighlight %}

You can completely remove a token using the `jerakia token delete` command

{% highlight none %}
# jerakia token delete my_app
{% endhighlight %}

 Note that disabling, enabling or deleting tokens will not take effect until Jerakia Server refreshes it's token cache, which by default happens every 300 seconds.  See the `token_ttl` setting in [the server documentation](/server/usage).
