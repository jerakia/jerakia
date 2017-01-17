---
layout: default
---

## HTTP Datasource

The HTTP datasource can be used to lookup data from any REST API such as CouchDB.  The http datasource uses the [lookup_http library](https://github.com/crayfishx/lookup_http).


### Example

{% highlight ruby %}
lookup :foo do
  datasource :http, {
    :host    => "127.0.0.1",
    :port    => 5984,
    :output  => "json",
    :paths  => [
      "/configuration/#{scope[:environment]}",
      "/configuration/global",
    ]
  }
end
{% endhighlight %}

## Options

### Global Options

#### `host`
Hostname to connect to

#### `port`
Port to connect to

#### `paths`
An array containing a list of paths that will be called in order. Eg:

{%highlight ruby%}
    :paths  => [
      "/configuration/#{scope[:environment]}",
      "/configuration/global",
    ]
{% endhighlight %}

#### `output`
Specify what handler to use for the output of the request.  Currently supported outputs are plain, which will just return the whole document, or YAML and JSON which parse the data and try to look up the key

#### `failure`
When set to `graceful` will stop hiera-http from throwing an exception in the event of a connection error, timeout or invalid HTTP response and move on.  Without this option set hiera-http will throw an exception in such circumstances

#### `ignore_404`
If `failure` is _not_ set to `graceful` then any error code received from the HTTP response will throw an exception.  This option makes 404 responses exempt from exceptions.  This is useful if you expect to get 404's for data items not in a certain part of the hierarchy and need to fall back to the next level in the hierarchy, but you still want to bomb out on other errors.

#### `headers`
Hash of headers to send in the request

### SSL Options

#### `use_ssl`
When set to true, enable SSL (default: false)

#### `ssl_ca_cert`
Specify a CA cert to use with SSL

#### `ssl_cert`
Specify location of SSL certificate

#### `ssl_hey`
Specify the location of SSL key

#### `ssl_verify`
Whether to verify SSL connections (default: true)

### HTTP AUTH options

#### `use_auth`
When set to true, enable basic auth (default: false)

#### `auth_user`
The user to use for basic auth

### `auth_pass`
The password to use for basic auth
