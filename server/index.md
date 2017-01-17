---
layout: default
---

# Jerakia Server

## Introduction

Jerakia Server released in Jerakia 1.2, it provides a server to expose Jerakia lookup functionality over a REST API to enable easier integration with other tools, and portability for the Jerakia platform to reside on different servers.  Jerakia Server by default binds to localhost using HTTP, a simple reverse proxy such as nginx can be used to expose the API over HTTPS across the network.  Jerakia uses [authentication tokens](/server/tokens) to control access from different applications.

Currently Jerakia Server offers a REST API supporting;

* Performing data lookups
* Sending, storing and retrieving scope data

See the [usage instructions](/server/usage) for information on how to start Jerakia Server and [the API documentation](/server/api) for details of how to interact with the API.  There is also a [jerakia-client gem](https://github.com/crayfishx/jerakia-client) which provides ruby bindings and a CLI for interacting with Jerakia Server over REST.


