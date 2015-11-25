---
layout: minimal
---

## About Jerakia

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


