[![Jerakia](http://jerakia.io/lerakia-logo.png)](http://jerakia.io)

## [http://jerakia.io](http://jerakia.io)


[![Build Status](https://travis-ci.org/crayfishx/jerakia.svg?branch=master)](https://travis-ci.org/crayfishx/jerakia) [![Gem Version](https://badge.fury.io/rb/jerakia.svg)](https://badge.fury.io/rb/jerakia)


jerakia
=========

[![Join the chat at https://gitter.im/crayfishx/jerakia](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/crayfishx/jerakia?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A pluggable and extendable hierarchical data lookup system

## Introduction ##

Jerakia is a tool that performs key value lookups against a variety of pluggable data stores. It does this using a top-down hierarchical set of queries that allow you to define global values and override them at different levels of a configurable hierarchy.  This has many use cases, including infrastructure management where you often have configuration values defined at a global level but wish to override these values based on certain factors such as the environment or location of the request.

Key value pairs of data are looked up using a top-down search path allowing you to override values in a hierarchical way. Jerakia recieves a key to lookup a long with information about the requestor, using that information it traverses down a preconfigured hierarchy of queries until it finds the most relevant answer to return

The main goals and features of Jerakia are:

* Hierarchical key value data lookups
* Extendable framework to solve even the most complex edge cases
* Decoupled from any particular configuration management system
* Pluggable framework to encourage community plugin development

Features include:

* YAML and JSON data source nativly included
* HTTP REST API data source nativly included
* Integration with Hashicorp Vault for encrypted secret lookups
* REST server API

## Usage and Documentation ##

Documentation is kept on the [Official Website](http://jerakia.io)

Get help and support on [the Jerakia users mailing list](https://groups.google.com/a/enviatics.com/d/forum/jerakia-users)

## Other documentation ##
* [Blog post: Understanding Hierarchichal Data Lookups](https://www.craigdunn.org/2017/08/understanding-hierarchical-data-lookups/)
* [Blog post part 1: Solving real world problems with Jerakia](http://www.craigdunn.org/2015/09/solving-real-world-problems-with-jerakia/)
* [Blog post part 2: Extending Jerakia with lookup plugins](http://www.craigdunn.org/2015/09/extending-jerakia-with-lookup-plugins/)
* [Blog post: Managing Puppet Secrets with Jerakia and Vault](http://www.craigdunn.org/2017/04/managing-puppet-secrets-with-jerakia-and-vault/)
* [Blog post: Using data schemas with Jerakia](http://www.craigdunn.org/2016/03/using-data-schemas-with-jerakia-0-5/)
* [Blog post: Extending Jerakia with lookup plugins](http://www.craigdunn.org/2015/09/extending-jerakia-with-lookup-plugins/)

## Architecture ##

Jerakia is a policy based lookup system.  A lookup request consists of a key, a namespace and a scope.  The scope sets a list of key value pairs used for determining how the request is handled (eg: environment => development).  Scopes are also pluggable and Jerakia can set the scope data in a variety of ways, by default it is passed as metadata information within the request, but other future options include PuppetDB, MCollective...etc.  Each search request is passed to a pre-determined policy.  The policy dictates a series of lookups that should be performed and in what order.  Each lookup uses a configurable and pluggable data source to search for the lookup key.  Lookups support various plugins to control and manipulate lookup requests and the final result returned from the back end data source is then optionally passed through a number of response filters before the data is finally serialized in a common format (JSON) and returned to the requestor.

## Integration ##

There are various integration options for making requests to Jerakia.

* Command line tool
* Ruby API
* REST API
* [Hiera 5 Backend](http://forge.puppet.com/crayfishx/jerakia)
* [Ansible Lookup Plugin](https://github.com/crayfishx/ansible-jerakia)

Legacy (see [jerakia-puppet](https://github.com/crayfishx/jerakia-puppet) ):

* Puppet data binding terminus
* Hiera 3.x Backend

Future integrations with other tools such as Chef and Rundeck are under development

## Help and support ##

Raise issues on the github page, we would love to hear any feature requests that aren't currently covered by jerakia.  There is also an IRC channel on freenode, #jerakia


## License ##

Jerakia is distributed under the Apache 2.0 license

## Achnowledgements ##

* Sponsered by Baloise Group [http://baloise.github.io](http://baloise.github.io)


