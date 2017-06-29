# Jerakia Release Notes

## 2.1.0
* Tighter permissions on logfile and configuration file when installing with system packages (https://github.com/crayfishx/jerakia/pull/85)
* Bugfix: An issue in 2.0.0 meant that if you use `stop` with a `confine` or `exclude` statement in a lookup, that the lookup never actually gets invoked (https://github.com/crayfishx/jerakia/pull/86)
* Fixed issues installing on Debian using apt (https://github.com/crayfishx/jerakia/pull/83)
* Fixed HTTP datasource to be compatible with the new datasource API (https://github.com/crayfishx/jerakia/pull/82)



### 2.0.1

* Fixed default location of logfile to be `/var/log/jerakia/jerakia.log`
* Added default for `databasedir` to point to `/var/db/jerakia`



# 2.0.0

The main additions for 2.0 are the introduction of encryption as a first class citizen and integration with the _transit_ secret backend for vault to provide encryption.  We've also changed the API for datasources to make them easier to write.

2.0 removes some features, particularly around Puppet integration that are now available as a third party plugin rather than shipped in Jerakia core.
## Features

* Introduced encryption as a first class citizen to Jerakia
* Encryption services are now pluggable with the default being Vault transit
* The output provider `:encryption` now uses whichever encryption provider has been configured
* API changes to data sources to make them more understandable
* Lookups can now be accepted without a key or a namespace, this is paving the way for data sources that can potentially be _keyless_ - eg: return all data in one query.
* The legacy Puppet data binding terminus and Hiera 3.x backend have been removed from core but are still available with the `jerakia-puppet` rubygem.
* Integration with Puppet 4.9+ is now via a Hiera 5 data provider function in the `crayfishx/jerakia` Puppet module

### 1.2.1

* Fixed omision from 1.2 that failed to authenticate tokens using the API


## 1.2.0

* New feature, Jerakia Server
* New feature, PuppetDB scope handler
* This release has many additions, please see the [full release notes](http://jerakia.io/releasenotes/1_2) for complete documentation

### 1.1.2

* Various bugfixes around resource cloning between lookups, and from the CLI (https://github.com/crayfishx/jerakia/pull/61).

### 1.1.1

* Fix for [#58](https://github.com/crayfishx/jerakia/pull/58), boolean options for data sources with true as a default not overridable.
* Fix for [#59](https://github.com/crayfishx/jerakia/pull/59), HTTP datasource incorrectly parsing nil return  (ref: https://github.com/crayfishx/lookup_http/issues/2)


## 1.1.0

* Fix for [#54](https://github.com/crayfishx/jerakia/pull/54), multiple lookups in a policy sometimes cause exceptions with cascading look
ups. Fixed.
* Enhanced error handling
* Internal refactor of DSL parser and other code cleanups
* More spec tests

### 1.0.1

* Changed clone_request to use .clone() instead of Marshal.dump, this fixes some very strange behaviour under specific circumstances in Puppet. [see #53](https://github.com/crayfishx/jerakia/pull/53)

# 1.0.0

* Stable release, no functional changes since 0.5.3


### 0.5.2
* Bugfix: Issue #41, fixes problem where the boolean false is returned as nil.

### 0.5.1
* Bugfix: deep_merge gem missing from Gem dependancies
* Feature: added yaml output (--output yaml) for the command line

## 0.5.0

* [Issue #9](https://github.com/crayfishx/jerakia/issues/9) : Added [data schema](/schema/) feature
* [Issue #12](https://github.com/crayfishx/jerakia/issues/12): Added deep merge capability
* [Issue #35](https://github.com/crayfishx/jerakia/issues/35): Bugfix: reverse priority given to hash merges
* [Issue #33](https://github.com/crayfishx/jerakia/issues/33): Use default values for jerakia.yaml options so file is not mandatory
* [Issue #36](https://github.com/crayfishx/jerakia/issues/36): Plugins now support an `autorun` method to run upon use without needing to call plugin methods
* [Issue #37](https://github.com/crayfishx/jerakia/issues/37): Configuration can now be passed to Jerakia plugins from `jerakia.yaml` in a `plugins` hash.
* Misc: `plugin.hiera.rewrite_lookup` is now deprecated (currently warns), this feature is now run using the autorun method
* Misc: File data source now supports a JSON file handler

###  0.4.5:
*  Bug fix release: fix for looking up nested vars (eg: foo::bar::bob) from Hiera

### 0.4.4:
* --verbose feature added to show lookup keys
* Fixed issues with declaring alternative scope handlers
* Added YAML scope handler
* Policy can be overriden using request metadata
* Data sources can define multiple types for their options 
* Integration tests added for data bindings, hiera lookups and puppet runs
* JERAKIA_CONFIG environment variable can be used to set the jerakia.yaml location
* internal minor bug fixes

### 0.4.3:
* --debug feature added to the CLI to log to stdout

### 0.4.2:
* Bugfix: hiera backend throwing errors with unresolvable 'config' method

### 0.4.1:
* Added Jerakia::VERSION constant
* Added version flag to CLI

## 0.4.0:
* *BREAK* - CLI overhaul of the jerakia command line (David Danzilio)
* Feature: Fragments (.d) support for the file datasource
* Numerous testing enhancements
* Internal improvements

## 0.3.0:
* *BREAK* by default, jerakia will now use .yaml instead of .yml for all YAML files.

## 0.2.0:
* introduced HTTP datasource using lookup_http

