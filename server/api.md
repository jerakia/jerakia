---
layout: default
---

# Jerakia Server

# API

## Introduction

This describes the API for integrating with Jerakia Server over HTTP

## Authentication

Each request must authenticate itself by sending a valid token in the `X-Authentication` HTTP header. See [tokens documentation](/server/tokens) for details on how to create tokens. This is an example of using curl to perform a lookup against the Jerakia Server API.

{% highlight none %}
curl -X GET -H 'X-Authentication: my_app:ac2a313db95bf5d034732d9c8b202ed61b0c369fffe61cd3bdce7642df9bf8602094d01fc35c82a5' http://localhost:9843/v1/lookup/cities?namespace=test

{"status":"ok","payload":{"france":"paris","argentina":"buenos aires","spain":"malaga"}}
{% endhighlight %}

## Responses

Jerakia responds with a JSON hash, see the endpoint documentation below for a description of the elements of the response for each endpoint.

## Requests

An HTTP request should contain the API version and the path to the endpoint. Currently the API version is `v1`.

Prior to version 2.3 of jerakia, only the content type `json` was supported. From version 2.4 on jerakia supports either [json](http://json.org/) or [msgpack](http://msgpack.org/) as a content type. For backwards compatibility the server uses json as the default content type if the client sents no content type or explicit `application/json`.

When using `applictation/json` be aware that JSON uses strings as keys which may result in different behavior then when using jerakia through the hiera backend, depending on your data.

{% highlight none %}
curl -X GET -H 'content_type: application/json' -H 'X-Authentication: my_app:ac2a313db95bf5d034732d9c8b202ed61b0c369fffe61cd3bdce7642df9bf8602094d01fc35c82a5' http://localhost:9843/v1/lookup/cities?namespace=test

{"status":"ok","payload":{"france":"paris","argentina":"buenos aires","spain":"malaga"}}
{% endhighlight %}

To use msgpack as the dataformat it is necessary to set the content type to `application/x-msgpack:

{% highlight none %}
$ curl -X GET -H 'content_type: application/x-msgpack' -H 'X-Authentication: my_app:ac2a313db95bf5d034732d9c8b202ed61b0c369fffe61cd3bdce7642df9bf8602094d01fc35c82a5' http://localhost:9992/v1/lookup/cities?namespace=test
▒▒status▒ok▒payload▒▒france▒paris▒argentina▒buenos aires▒spain▒malaga
{% endhighlight %}

## Lookups

### Lookup endpoint

The lookup endpoint takes a lookup key with parameters to control how the lookup is executed and returns the data in the `payload` element of the response.  `payload` will be `null` if no data is found.

#### Request Path

`GET /v1/lookup/<key>`

Example:

`GET /v1/lookup/port?namespace=apache`

#### Params

* `namespace`: The namespace to use for the request.  Nested namespaces should be delimited with `/`
* `policy`: Optionally override the policy used for the request
* `lookup_type`: Optionally override the type of lookup (`first`, `cascade`)
* `merge`: Optionally override the merge strategy to use (`array`, `deep_hash`, `hash`)
* `scope`: Provide an alternative scope handler to use for the request (eg: `puppetdb`)
* `scope_*`: This parameter is dynamic. Parameters matching `/^scope_.*/` are stripped of the `scope_` part and sent as parameters to the scope handler
* `metadata_*`: This parameter is dynamic.  Parameters matching `/^metadata_.*/` are stripped of the `metadata_` part and are combined to form the metadata hash for the request.

#### Response

* `status`: `ok` or `failed`
* `payload`: The data returned from the lookup, if the lookup did not return any results this element is `null`
* `message`: Details of the error if `status` is `failed`

### Keyless lookup endpoint

#### Request Path

`GET /v1/lookup`

Currently not implemented, Reserved for upcoming feature.


## Scope endpoints

In some circumstances, such as integrating Puppet with Jerakia Server over REST, we don't want to have to send the scope data with every request as this can become expensive so Jerakia 1.2+ ships with a scope handler called `server`.  Scope data can be sent to Jerakia Server in advance of the lookup and refreshed at any time via the API, the scope is stored in an in-memory database on the server with a realm and identifier combination unique to that scope set.  Future lookups can specify the scope handler `server` in their lookup request and provide the `realm` and `identifier` scope options.

### Scope Storage Endpoint

If a scope set already exists for the realm and identifier provided, then it will be replaced.  If not, one wll be created.

#### Request path

`PUT /v1/scope/<realm>/<identifier>`

Example

`PUT /v1/scope/puppet/agent1.localdomain`

#### Payload

The payload of the `PUT` request should be the scope data, in JSON format.

#### Response
* `status`: `ok` or `failed`
* `uuid`: A unique identifier for this revision of the scope data
* `message`: Reason for failure if status is `failed`

 
### Scope Retrieval Endpoint

You can also retrieve the current scope set from the API using a `GET` call

#### Request Path

`GET /v1/scope/<realm>/<identifier>`

Example:

`GET /v1/scope/puppet/agent1.localdomain`

#### Response

* `status`: `ok` or `failed`
* `payload`: The data contained within the scope.
* `message`: Reason for failure if status is `failed`

### Scope validation endpoint.

You can validate whether a UUID is still valid by submitting a `GET` request to the validation endpoint

#### Request Path

`GET /v1/scope/<realm>/<identifier>/<uuid>`

Example:

`GET /v1/scope/puppet/agent1.localdomain/558456d5-dea5-407d-888a-90933abfb7e9``

#### Response

* `status`: `ok` or `failed`
* `uuid`: The UUID of the stored scope set
* `message`: Reason for failure if status is `failed`







