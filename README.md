jerakia
=========

[![Join the chat at https://gitter.im/crayfishx/jerakia](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/crayfishx/jerakia?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A pluggable and extendable data lookup system

## Development status ##

This project is still in a prototype development stage - it shouldn't be considered suitable for production use without extensive review until 1.0, versioning will be:

* 0.0.x + : Volatile, in extensive development, every release should be considered a break release
* 0.1.x + : Minor version considered breaking change, patch version may add features
* 1.0.0 + : Stable release, all versions from 1.0.0 onward will adhere to semver

## Introduction ##

Jerakia is a pluggable hierarchical data lookup engine.  It is not a database, Jerakia itself does not store any data but rather gives a single point of access to your data via a variety of back end data sources.   Jerakia is inspired by Hiera, and can be used a drop in replacement. Hiera itself is a good tool, however it suffers from some degree of limitation in its architecture that makes solving complex edge cases a challenge. Jerakia is an attempt at a different way of approaching data lookup management.  Jerakia started out as a prototype experiment to replace hiera in order to solve a number of complicated requirements for a particular project, over time it matured a bit and we decided to open source it and move it towards a standalone data lookup system.

The main goals of Jerakia are:

* Extendable framework to solve even the most complex edge cases
* Decoupled from any particular configuration management system
* Pluggable framework to encourage community plugin development

Features include:

* YAML and JSON data source nativly included
* HTTP REST API data source nativly included
* hiera-eyaml style decryption of data from any data source
* REST server API (experimental)

## Usage and Documentation ##

It is recommended you [read the documentation here](./doc/index.md) before continuing.

Documentation is ongoing, but for the impatient, and for people already familar with Hiera See the [Puppet users tutorial](doc/getting_started.md) page for a quick start guide!


## Architecture ##

Jerakia is a policy based lookup system.  A lookup request consists of a key, a namespace and a scope.  The scope sets a list of key value pairs used for determining how the request is handled (eg: environment => development).  Scopes are also pluggable and Jerakia can set the scope data in a variety of ways, by default it is passed as metadata information within the request, but other future options include PuppetDB, MCollective...etc.  Each search request is passed to a pre-determined policy.  The policy dictates a series of lookups that should be performed and in what order.  Each lookup uses a configurable and pluggable data source to search for the lookup key.  Lookups support various plugins to control and manipulate lookup requests and the final result returned from the back end data source is then optionally passed through a number of response filters before the data is finally serialized in a common format (JSON) and returned to the requestor.

## Puppet ##

For Puppet users wishing to test or migrate to Jerakia there are a number of options.  Jerakia ships with a Puppet data binding terminus that can be enabled with a simple configuration directive in Puppet's configuration file causing all data binding lookups from parameterised classes to Jerakia rather than Puppet's native Hiera.  Like Hiera, Jerakia supports a file based data source for looking up data in YAML or JSON source files.  By default, Jerakia has a slightly different filesystem layout and lookup format than hiera, however, if you wish to retain your existing data files this can be enabled using the _hiera_compat_ lookup plugin.  [Read more about Hiera compatability and integration here](./docs/quickstart_puppet.md).

## Integration ##

There are various integration options for making requests to Jerakia.

* Command line tool
* Ruby API
* REST API (experimental)
* Puppet data binding terminus
* Hiera Backend

Future integrations with other tools such as Chef and Rundeck are under development

## Features in active development ##
* Better logging
* Better caching
* PuppetDB and MCollective scope plugins
* HTTP datasource
* ENC integration

## Help and support ##

Raise issues on the github page, we would love to hear any feature requests that aren't currently covered by jerakia.  There is also an IRC channel on freenode, #jerakia


## License ##

Jerakia is distributed under the Apache 2.0 license

## Achnowledgements ##

* Sponsered by Baloise Group [http://baloise.github.io](http://baloise.github.io)


