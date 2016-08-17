---
layout: minimal
---

# Jerakia

## About Jerakia

Jerakia is a pluggable hierarchical data lookup engine.  It is not a database, Jerakia itself does not store any data but rather gives a single point of access to your data via a variety of back end data sources.   Jerakia is inspired by Hiera, and can be used an additional backend or as a complete drop in replacement. 

## Data Separation

Managing data can be a complex task.  With tools such as Puppet deployed to configure your entire software stack across multiple locations and environments, deciding on what configuration options and other site specific data should be configured where becomes cumbersome within your code.  Data separation refers to splitting out your site specific data from your code.  You gain the ability to write and use generic modules from the public domian without needing to modify them, and complex conditional logic in your code to determine what configuration values should be in a given environment is a thing of the past.

## Why Jerakia

Jerakia is built on one core principle: flexibility.  When you go beyond small-scale, single-customer orientated implementations into larger, more complex and diverse environments the role of modelling your data can become challenging.  Some examples of these challenges include;

* Using a different data source for one particular application.
* Giving a team a separate hierarchy just for their application.
* Giving access to a subset of data to a particular user or team.
* Enjoy the benefits of eyaml encryption without having to use YAML.
* Dynamic hierarchy rather than hard coded it in config.
* Separation of configuration between applications.

Jerakia is a policy driven model.  Policies are written in Ruby DSL which gives a high degree of flexibility in solving complex edge cases.  An example of a simple Jerakia policy is;

{% highlight ruby %}
policy :default do
  lookup :main do
    datasource :file, {
      :format => :yaml,
      :docroot => '/var/lib/jerakia/data',
      :searchpath => [
        "hostname/#{scope[:certname]}",
        "environment/#{scope[:environment]}",
        'common',
      ]
    },
  end
end
{% endhighlight %}     

Nearly everything in Jerakia is extendable and pluggable making it very easy to write and share your own extensions to Jerakia, from lookup plugins, data sources, scope handlers, output filters and more.


Features of Jerakia also include:

* YAML and JSON data source nativly included
* HTTP REST API data source nativly included
* hiera-eyaml style decryption of data from any data source
* REST server API (experimental)

# References

* [Craig Dunn's slides from Config Management Camp introducing Jerakia](http://www.slideshare.net/CraigDunn3/solving-real-world-data-problems-with-jerakia?qid=f858521d-cb0e-41a4-a1ce-cc42accbb726&v=&b=&from_search=1)
* [Blog post: Solving real world problems with Jerakia](http://www.craigdunn.org/2015/09/solving-real-world-problems-with-jerakia/)
* [Blog post: Extending Jerakia with lookup plugins](http://www.craigdunn.org/2015/09/extending-jerakia-with-lookup-plugins/)

# Latest News

## Jerakia goes 1.0.0

Jerakia is now officially 1.0.0.  It's been running in production for several large projects for nearly a year now and we feel that it's time to mature it.  This also means (unlike the 0.x series) we will now be adhering strictly to semver (semantic versioning) giving extra quality assurance around our releases.  Thank you to our users and our sponsors.


## Jerakia 0.4 released.

Jerakia 0.4 series ships with a number of bug fixes and enhancements.  Also included is the _fragments_ feature for the file datasource allowing large files to be split up into _.d_ style structures making them easier to manage.
