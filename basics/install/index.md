---
layout: default
---

# Installing

## Install using All-in-one (AIO) system packages (DEB/RPM)

Jerakia 1.2+ ships as a completely self contained system package available on Debian, Ubuntu and Redhat/CentOS based systems.  This is the recommended installation method for users wanting to run Jerakia Server and connect to Jerakia from other tools using the API.  We use [Packager.io](https://packager.io/gh/crayfishx/jerakia) for automated package building and repo hosting.  

There are two repositories available,  `testing` contains experimental and pre-releases and should never be used in production, these are for people wishing to test the latest features of Jerakia before they are released.  The `stable` repo contains official releases.

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


## Alternative methods

### Install using Rubygems

Jerakia is available as a Rubygem and can be installed with

{% highlight none %}
$ gem install jerakia
{% endhighlight %}

After installing the gem, proceed to [configure Jerakia](/basics/configure)

### Install Jerakia using Docker

Jerakia 1.2 also ships in a docker container, to use it simply pull it from Docker Hub

{% highlight none %}
# docker pull crayfishx/jerakia
{% endhighlight %}

See [the documentation on Docker Hub](https://hub.docker.com/r/crayfishx/jerakia/) for more information on usage
