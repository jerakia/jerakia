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

#### `lookup_key`
By default the HTTP datasource expects a data structure and attempts to resolve the key from the returned data.  This isn't always desirable, setting `lookup_key` to `false` will disable this behaviour and return the whole document.  See "Data digging" for a more expansive explanation of this.   Note: In Jerakia 2.x this option defaults to `true`, it is planned that in Jerakia 3 this will default to `false` so the datasource will always return the entire data set.


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

## Data Digging

The default behaviour of the HTTP data source is to expect a hash of key value pairs and try and resolve the lookup key, for example, when looking up the key `port` in the `apache` namespace the HTTP datasource would require returned data from the endpoint something like;

{% highlight json %}
{
  "port": 80
}
{% endhighlight %}

This isn't particularly flexible in using the HTTP data source with a variety of different end points that may have differing ways of returning data.  Jerakia 2.5 addresses this issue with the addition of the `lookup_key` flag to the HTTP datasource and a new output filter, called `dig`, used together they make the HTTP datasource a lot more flexible.

When `lookup_key` is set to `false` the HTTP will not attempt to resolve the key, so instead of returning `80` in the above example, it will return the whole data set of `{ "port": 80 }`

Using the [dig output filter](/outputfilters/dig) we can achieve the same results as before

{% highlight ruby %}
lookup :default do
  datasource :http, {
    ...
    :lookup_key => false,
  }

  output_filter :dig, [ request.key ]
end
{% endhighlight %}

Now consider a more complex example, if the endpoint we are talking to returns a hash of key value pairs under a nested hash, eg:

{% highlight json %}
{
  "document": {
    "settings": {
      "apache": {
        "port": 80
      }
    }
  }
}
{% endhighlight %}

This return data is clearly incompatible with the HTTP datasource with the default legacy lookup key mode enabled, but when we set this to false and combine it with the dig datasource we can tailor the behaviour of the lookup;

{% highlight ruby %}
lookup :default do
  datasource :http, {
    ...
    :lookup_key => false,
  }

  output_filter :dig, [ "document", "settings", request.namespace, request.key ]
end
{% endhighlight %}

_Important_: In Jerakia 3.0 the default behaviour of `lookup_key` will be set to `false` in the HTTP datasource
