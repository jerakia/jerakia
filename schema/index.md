---
layout: minimal
---

# Jerakia Schemas

## About Schemas

Schemas are available in Jerakia 0.5.0+

A schema is a set of data that defined various aspects about data contained within the source.  A schema can be used to alter the lookup behaviour of Jerakia for a particular key, such as making it a cascading array lookup.  Schemas also support aliasing giving them the ability to expose pseuedo data that maps to a different namespace and key within your data.

Schemas are looked up internally using the file datasource, they can currently be defined in JSON or YAML format (default JSON).  The design allows for the use of other more customizable schema lookup functionality using custom written policies in future releases.

## Using Schemas

Jerakia uses the file datasource to search for a schema JSON file matching the namespace of the lookup.  Currently JSON and YAML can be supported (see configuration below) and the roadmap for this feature allows for a number of other backends to be used for sourcing schema data in the future.

### Creating a JSON schema file

By default, Jerakia will search for schema data in `/var/lib/jerakia/schema` and look for a file matching `<namespace>.yaml` (or `namespace1/namespace2.yaml` for nested namespaces)

{% highlight ruby %}
# vim /var/lib/jerakia/schema/accounts.json
{% endhighlight %}

{% highlight json %}
{
  "users": {
    "cascade": true,
    "merge": "hash",
  }
}
{% endhighlight %}

When schema lookups are enabled, this will override the lookup of the key users in the namespace accounts (`accounts::users`) and make Jerakia perform a cascading array lookup, the equivilent of setting `--type cascade --merge array` on the command line.

### Writing schema definitions

Each key of the JSON hash refers to a lookup key within the namespace.  Supported sub-keys are:

* `cascade`:  `true` or `false`, controls whether the lookup should stop at the first response or cascade through the hierarchy
* `merge`: `array`, `hash` or `deep_hash`, controls how to merge multiple results when `cascade` is set to `true`
* `alias`: Takes a hash with a combination of `key` and/or `namespace` and makes the defined key or namespace an alias for another (see below)

### Examples

#### Lookup behaviour

Schemas allow you to control the lookup behaviour without manipulating the request.  For example, from Puppet, they allow you to specify that a particular key must be looked up as a cascading array, or merged hash, without having to specify that in the Puppet manifests or embedded in the data iteself, since schemas are separate from the actual data store.  This is particularly useful for variables that are resolved through data binding or standard lookups where you need to be able to change the lookup behaviour.

Example:
{% highlight ruby %}
# vim /var/lib/jerakia/schema/people.json
{% endhighlight %}

{% highlight json %}

{
  "users": {
    "cascade": true,
    "merge": "deep_hash"
  }
}

{% endhighlight %}

#### Aliasing

Aliasing is a useful feature of schemas that allows you to create a pseudo key, or namespace, as an alias for another key or namespace and also override the lookup behaviour.  This can be especially useful when two different lookups of the same key require the behaviour to be different, or if you need to rename keys or namespaces and maintain consistency and backwards compatibility.

Suppose we have the following data in Jerakia

{% highlight yaml %}
# env/development/accounts.yaml
---
users:
  - bob
  - fred
  - lucy
{% endhighlight %}

{% highlight yaml %}
# common/accounts.yaml
---
users:
  - susan
  - craig
  - lizzie

{% endhighlight %}

This data could be looked up using the namespace `accounts` and the key `users`, we can also create an alias pointer to this data in the schema so the same data can be looked up with a different key and/or namespace.

{% highlight ruby %}
# vim /var/lib/jerakia/schema/people.json
{% endhighlight %}

{% highlight json %}
{
  "sysadmins": {
    "alias": {
      "namespace": "accounts",
      "key": "users"
    }
  }
}
{% endhighlight %}

We now have the ability to to query the `sysadmins` key in the `people` namespace (`people::sysadmins`) and because this is a schema alias, Jerakia will return the data for the `users` key in the `accounts` namespace.

You can also mix lookup behaviour directives with aliases to create different pseudo keys that have different lookup behaviours.

{% highlight json %}
{
  "sysadmins": {
    "alias": {
      "namespace": "accounts",
      "key": "users"
    }
  },
  "all_sysadmins": {
    "alias": {
      "namespace": "accounts",
      "key": "users"
    },
    "cascade": true,
    "merge": "array",
  }
}
{% endhighlight %}

Now we have two pseudo keys, `people::sysadmins` and `people::all_sysadmins`, both pull data from the `users::accounts`, so this data is only declared once, but depending on which pseudo lookup key we use the results will be different.

## Configuration

### Enabling and disabling schemas

Schemas are enabled by default in 0.5.0 but can be completely disabled by setting `enable_schemas` to `false` in `jerakia.yaml` see [configuring Jerakia](/basics/configure/) for more information.

### Customizing schema lookups

Schemas use the file datasource to perform a lookup using the key and namespace in the original request.  The behaviour of the lookup can be controlled by configuring a hash called `schema` in `jerakia.yaml`.  Supported configuration options are:

`docroot`: set the document root of Jerakia schema lookups
`format`: Defaults to "json", set the lookup format for schemas ("yaml" or "json")
`enable_caching`: Defaults to true, whether or not to cache schema lookups

Example:

{% highlight yaml %}
schema:
  docroot: /etc/jerakia/schemas
{% endhighlight %}
