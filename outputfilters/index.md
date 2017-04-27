---
layout: default
---

# Output Filters

## Introduction

Output filters are an optional addition to a lookup, when an output filter is defined, the answer from a lookup is passed to the filter prior to being sent back to the requestor.  This allows for parsing and modification of answers in a lookup in a pluggable way.  Output filters are defined using the `output_filter` method within a `lookup` block.

## Available filters

Currently there are two output filters shipped with Jerakia, `encryption` and `strsub`

### encryption

#### Description

The `encryption` output filter can be used if you have a [valid encryption provider](/encryption) loaded, such as Vault.  Encryption providers expose a signiture as a regular expression. With the `encryption` output filter enabled, any results that come back from any datasource matching the regex of the providers signiture (eg: vault:v1:ZDXtHprxLDnAJySOcyAnc5F2RJlIGtOnoxeJICQXUrYf9A3iOC76) then the string is passed to the decrypt method of the encryption provider to be decrypted before it's passed back to the requestor.

#### Usage

{% highlight ruby %}
policy :default do
  lookup :main do
    datasource :file {
      ...
    }
    output_filter :encryption
  end
end
{% endhighlight %}

### strsub

#### Description

The `strsub` filter will parse the data for strings matching `%{var}` and attempt to replace the tag with the corresponding value `var` from the scope provided with the lookup.

#### Usage

{% highlight ruby %}
    output_filter :strsub
{% endhighlight %}


