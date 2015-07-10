jacaranda
=========

A pluggable and extendable data lookup system

## Development status ##

This project is still in a prototype development stage - it shouldn't be considered suitable for production use without extensive review until 1.0, versioning will be:

* 0.0.x + : Volatile, in extensive development, every release should be considered a break release
* 0.1.x + : Minor version considered breaking change, patch version may add features
* 1.0.0 + : Stable release, all versions from 1.0.0 onward will ahere to semver

## Introduction ##

Jacaranda is a pluggable hierarchical data lookup engine.  It is not a database, Jacaranda itself does not store any data but rather gives a single point of access to your data via a variety of back end data sources.   Jacaranda is inspired by Hiera, and can be used a drop in replacement. Hiera itself is a good tool, however it suffers from some degree of limitation in its architecture that makes solving complex edge cases a challenge. Jacaranda is an attempt at a different way of approaching data lookup management.

The main goals of Jacaranda are:

* Extendable framework to solve even the most complex edge cases
* Decoupled from any particular configuration management system
* Pluggable framework to encourage community plugin development

Features include:

* YAML and JSON data source nativly included
* HTTP REST API data source nativly included
* hiera-eyaml style decryption of data from any data source
* REST server API (experimental)


## Architecture ##

Jacaranda is a policy based lookup system.  A lookup request consists of a key, a namespace and a scope.  The scope sets a list of key value pairs used for determining how the request is handled (eg: environment => development).  Scopes are also pluggable and Jacaranda can set the scope data in a variety of ways, by default it is passed as metadata information within the request, but other future options include PuppetDB, MCollective...etc.  Each search request is passed to a pre-determined policy.  The policy dictates a series of lookups that should be performed and in what order.  Each lookup uses a configurable and pluggable data source to search for the lookup key.  Lookups support various plugins to control and manipulate lookup requests and the final result returned from the back end data source is then optionally passed through a number of response filters before the data is finally serialized in a common format (JSON) and returned to the requestor.

## Puppet ##

For Puppet users wishing to test or migrate to Jacaranda there are a number of options.  Jacaranda ships with a Puppet data binding terminus that can be enabled with a simple configuration directive in Puppet's configuration file causing all data binding lookups from parameterised classes to Jacaranda rather than Puppet's native Hiera.  Like Hiera, Jacaranda supports a file based data source for looking up data in YAML or JSON source files.  By default, Jacaranda has a slightly different filesystem layout and lookup format than hiera, however, if you wish to retain your existing data files this can be enabled using the _hiera_compat_ lookup plugin.  [Read more about Puppet integration here](./docs/puppet.md).

## Integration ##

There are various integration options for making requests to Jacaranda.

* Command line tool
* Ruby API
* REST API (experimental)
* Puppet data binding terminus

Future integrations with other tools such as Chef and Rundeck are under development

## Documentation ##

It is recommended you [read the documentation here](./docs/index.md) before continuing.

## Features in development ##
* Better logging
* PuppetDB and MCollective scope plugins
* HTTP datasource
* ENC integration

## License ##

Jacaranda is distributed under the Apache 2.0 license

## Achnowledgements ##

* Sponsered by Baloise Group [http://baloise.github.io](http://baloise.github.io)


