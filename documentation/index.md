---
layout: default
title: Jerakia - A versatile data lookup system
---

## About

In essence, Jerakia is a tool that can be used to lookup a key value pair, that is to say, given a key it will give back the appropriate value.  This is certainly nothing special or new, but the crucial difference here is the way in which the data is looked up.  Rather than just querying a flat data source and returning the value for a requested key, when doing a hierarchical lookup we perform multiple queries against a configured hierarchy, transcending down to the next layer in the hierarchy until we find an answer.    The end result is that we can define key value pairs on a global basis but then override them under certain conditions based on the hierarchical resolution by placing that key value pair further up the hierarchy for a particular condition.

## Hierarchical Lookups

Let's look at a fairly simple example, you need to determine from a data lookup what currency you need to bill a user coming into your site.  You already have data that tells you which country and continent that your user is based in.  You determine that to start with you will bill everyone in _USD_ regardless of where they come from.  So you store the key currency with a value of _USD_ in a data source somewhere, and whenever a user starts a transaction, you look up that key, and they get billed in _USD_

Now comes the fun part.  You decide that you would like to now start billing customers from European countries in EUR.  Since you already know the continent your user is coming from you could add another key to your data store and then use conditional logic within your code to determine which key to look up, but now we're adding complexity within the code implementing conditional logic to determine how to resolve the correct value.  This is the very thing that hierarchical lookups aim to solve, to structure the data and perform the lookups in such a way that is transparent to the program requesting the data.

Lets add another layer of complexity, you've agreed to use EUR for all users based in Europe, but you must now account for the UK and Switzerland which deal in _GBP_ and _CHF_ respectively, and potentially more.  Now the demands for conditional logic on the program requesting the data are getting more complicated.  To avoid lots of very convoluted conditional logic in your code you could simply map every country in the world to a currency and look up one key, that would be the cleanest method right now.  But remember that we generally want to use _USD_ for everyone and only care about changing this default under certain circumstances.  If we think about this carefully, we have a hierarchy of importance.  The country (in the case of UK or Switzerland), the continent in the case of Europe and then the rest of the world.  This is where a hierarchical lookup simplifies the management of this data.  The hierarchy we need to search here is quite simple;


![A hierarchy](/images/currency.png){: .center-image }

When we're dealing with storing data for hierarchical searches, we end up with a tiered hierarchy that looks something like this.  A lookup request to Jerakia contains two things, they key that is being looked up, in this case "currency", and some data about the context of the request which Jerakia refers to as the scope.  In this instance the scope contains the country and continent of the user. The scope and the key are used together, so when we are talking about hierarchical lookups, rather than just saying **"return the value for this key"** we are saying **"return the value for this key in the context of this scope"**.  That's the main distinction between a normal key value lookup and a hierarchical lookup.  If you're thinking of ways to do this in a structured query language (SQL) or some other database API, you might be ok to solve this problem - but this is a stripped down example looking up one value, now imagine we throw in tax parameters, shipping costs, and other fun things into the mix - this becomes a complex beast - but not when we think of this as a simple hierarchy.

With a hierarchical data source we can declare a key value pair at the bottom level, in this case Worldwide.  We can set that to USD, at this point any lookup request for the currency will return USD.  But a hierarchical data source allows us to add a different value for the key "currency" at a different level of the hierarchy, for example we can add a value of EUR at the continent level that will only return that value if the continent is Europe.  We can then add separate entries right at the top of the hierarchy for the UK and Switzerland, for requests where the country meets that criteria.

From our program we are still making one lookup request for the data, but that data is looked up using a series of queries behind the scenes to resolve the right data.   Essentially the lookup will trigger up to three queries.  If one query doesn't return an answer (because there is nothing specific configured in that level of the hierarchy) then it will fall back to the next level, and keep going until it hits an answer, eventually landing at the last level, Worldwide in our example.   So a typical lookup for the currency of a user would be handled as;

* **_What is the value for currency for this specific country?_**
* **_What is the value for currency for this specific continent?_**
* **_What is the value for currency for everything worldwide?_**

Whichever level of the hierarchy responds first will win, meaning that if a user from China will get a value of USD - because we haven't specified anything for Asia or China on the continent or country levels of the hierarchy so the lookup will fall through to our default set at the "worldwide" level.  However, at the continent level of the hierarchy we specified an override of EUR for requests where the continent of the requestor is Europe, so users from Germany, France and Spain would get EUR.  This wouldn't be the case for the UK or Switzerland though because we've specifically overridden this at the country level, which is higher in the hierarchy so will win over the continent that the country belongs to.


So hierarchical lookups are generally about defining a value at the widest possible catchment (eg: worldwide) and moving up the hierarchy overriding that value at the right level.

What is key here is that rather than implementing three levels of conditional logic in our code, or mapping the lowest common denominator (country) one to one with currencies for every country in the world (remember in some cases we may not be able to identify the lowest common denominator) we have found a way to express the data in a simple way and provide one simple path to looking up the data.  Our program still makes one request for the key currency, the logic involved in resolving the correct value is completely transparent.

In this case, we had a scope (the country and continent of the requestor) and a hierarchy to search against that uses both elements of the scope and then falls back to a common catch all.


### Applying this to infrastructure management

Jerakia is standalone and can be used for any number of applications that can make use of a hierarchical type of data lookup, but it was originally built with configuration management in mind.  Infrastructure data lends itself incredibly well to this model of data lookup.  Infrastructure data tends to consist of any number of configurable attributes that are used to drive your infrastructure.  These could be DNS resolvers, server hostnames, IP addresses, ports, API endpoints.... there is a ton of stuff that we configure on our infrastructures, but most of it is hierarchical.  Generally speaking a lot of infrastructure data starts off with a baseline default, for example, what DNS resolver to use.  That could be a default value thats used across the whole of your company and you add that as a key value pair to a datastore.  Then you find yourself having to override that value for systems configured in your development environment because that environment can't connect to the production resolvers on your network, you then may deploy your production environment out to a second data centre and you need that location to be different.  But we are still dealing with simple hierarchies, so rather than programming conditionals to determine the resolution path of a DNS resolver we could build a simple hierarchy that best represents our infrastructure, such as;

![A hierarchy](/images/infra.png){: .center-image }


When dealing with a hierarchy like this, a data lookup must give us a key to lookup and  contain a scope that tells us the hostname, environment and location of the request. Using the same principles as before our lookup will make up to 4 queries;

* **_What is the DNS resolver for my particular hostname?_**
* **_What is the DNS resolver for machines that are in my environment?_**
* **_What is the DNS resolver for machines that are in my location?_**
* **_What is the DNS resolver for everyone else?_**

Again, this is hierarchical search pattern that will stop at the first query to return an answer and return that value.  We can set our global parameters and then override them at the areas we care about.  We've even got a top level hierarchy entry for that one edge case special snowflake server that is different from everything else on the network, but the lookup method is identical and transparent to the application requesting the data.

## Jerakia

This is a generic overview of hierarchical lookups, but in particular as they relate to Jerakia.  Jerakia has way more features that build on top of this principle, like cascading lookups which don't stop at the first result and will build a combined data structure (HashMap or Array) from all levels of the hierarchy and return a unified result based on the route taken through the hierarchy, and I'll cover those in a follow up post.  It's also built to be extremely flexible and pluggable allowing you to source your data from pretty much anywhere and ships with an HTTP API meaning you can integrate Jerakia with any tool regardless of the underlying language.


# Documentation

Follow the links on the left for documentation on how to configure and use Jerakia.

# Further reading

## Blog posts

* [Solving real world problems with Jerakia](http://www.craigdunn.org/2015/09/solving-real-world-problems-with-jerakia/)
* [Extending Jerakia with lookup plugins](http://www.craigdunn.org/2015/09/extending-jerakia-with-lookup-plugins/)
* [Using Jerakia schemas](http://www.craigdunn.org/2016/03/using-data-schemas-with-jerakia-0-5/)

## Talks

* Presenting Jerakia, Configuration Management Camp 2016, Ghent.  [Slides available](http://www.slideshare.net/CraigDunn3/solving-real-world-data-problems-with-jerakia)
