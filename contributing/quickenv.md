---
layout: default
---

# Getting up and running in no time (for devs)

## Summary

If you are just looking to take Jerakia for a spin with no strings attached, or want to try stuff out in a development environment, you can do so very easily right from your home directory assuming you have bundler installed.  The `test/fixtures` directory in the git repo contains all the scaffolding needed for a fully working test environment, it's what our automated tests use.

* Configuration is at `test/fixtures/etc/jerakia/jerakia.yaml`
* Jerakia policies are at `test/fixtures/etc/jerakia/policy.d/`
* Data and schemas are at `test/fixtures/var/lib/jerakia/`
* You only need to set two environment variables for this to work out of the box, `RUBYLIB` and `JERAKIA_CONFIG`, and there is a script to do that.

## Get up and running

It's pretty simple, just clone the repo and set a couple of environment variables and you can use Jerakia.  You need to be in the root Jerakia folder to run commands as paths are relative.  Here is what you need to do

{% highlight bash %}
$ git clone https://github.com/crayfishx/jerakia
$ cd jerakia
$ bundle install
$ . test/environment.sh
{% endhighlight %}

If all went well, you should be able to run Jerakia from the root folder calling `./bin/jerakia`.   In our test data we have the key `cities` in the `test` namespace, so you should simply be able to run this as...

{% highlight bash %}
$ bin/jerakia lookup cities -n test
{"france"=>"paris", "argentina"=>"buenos aires", "spain"=>"malaga"}
{% endhighlight %}
