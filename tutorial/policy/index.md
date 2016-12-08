---
layout: default
---

# Quick start Tutorial

## Create a policy

Jerakia policies are containers for lookups.  When a lookup is invoked against Jerakia it can select a policy to use, by default, if no policy name is given then Jerakia will look for a policy called `default`

Policy files live within the directory defined in `policydir` in `jerakia.yaml`, so let's create an empty policy.

{% highlight console %}
$ mkdir /etc/jerakia/policy.d
$ vim /etc/jerakia/policy.d/default.rb
{% endhighlight %}

  

{% highlight ruby %}
policy :default do

end
{% endhighlight %}


Next: [Write a lookup](/tutorial/lookup)
