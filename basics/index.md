---
layout: default
---

# Jerakia Basics

Jerakia is a lookup application.  It is not itself a database, rather an entry point and routing mechanism to provide one point of entry for lookup up data from a variety of sources, which may include databases.

We use the following terminology

### Requestor
The requestor is the process, application or server sending the lookup request.  The requestor sends a lookup key and a namespace (see below) to Jerakia and waits for a response containing the matched data.

### Policy
When the requestor sends a lookup request to Jerakia, it is passed to a policy.  A Jerakia policy acts as a container for lookups that are called in order

### Lookup
A lookup is defined within a policy.  In the lookup we can model how, and from where, the data should be looked up.  Lookups can employ plugins to read and modify the lookup request, and define a datasource responsible for performing the actual lookup

### Datasources
A datasource is configured in a lookup.  Datasources are pluggable, Jerakia ships with two datasources;  `file` and `http`.

### Scope
The scope object contains key/value information used by the lookup to determine how to handle the lookup request.  Scopes are pluggable and the scope can be sourced from any scope plugin.  By default, Jerakia ships with the `metadata` scope handler which builds the scope data from metadata sent in the request object.  For example, when using Jerakia with Puppet, the scope contains the facts and top-level variables of the agent, which are passed to Jerakia as metadata in the request.   Future scope handlers may include things such as PuppetDB or MCollective to allow Jerakia lookups to source their scope from different places.


