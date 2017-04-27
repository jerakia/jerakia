---
layout: default
---

# Quick start Tutorial
Please read through the basics first, as this will help to provide some background for terminology used in this tutorial.

## Installation

First we need to install Jerakia

To install the latest stable version

### On CentOS / RedHat 7

{% highlight none %}
# rpm --import https://rpm.packager.io/key
# echo "[jerakia]
name=Repository for crayfishx/jerakia application.
baseurl=https://rpm.packager.io/gh/crayfishx/jerakia/centos7/stable
enabled=1" | tee /etc/yum.repos.d/jerakia.repo
# yum install jerakia
{% endhighlight %}

### On Debian 8

{% highlight none %}
# wget -qO - https://deb.packager.io/key | apt-key add -
# echo "deb https://deb.packager.io/gh/crayfishx/jerakia jessie stable" | tee /etc/apt/sources.list.d/jerakia.list
# apt-get update
# apt-get install jerakia
{% endhighlight %}

### On Ubuntu Xenial

{% highlight none %}
# wget -qO - https://deb.packager.io/key | apt-key add -
# echo "deb https://deb.packager.io/gh/crayfishx/jerakia xenial stable" | tee /etc/apt/sources.list.d/jerakia.list
# apt-get update
# apt-get install jerakia
{% endhighlight %}


Alternatively, you can install Jerakia as a Rubygem

{% highlight none %}
% gem install jerakia
{% endhighlight %}

Next: [Configuring Jerakia](/tutorial/config)
