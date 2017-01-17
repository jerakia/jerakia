---
layout: default
---

# Output Filters

## Introduction

Output filters are an optional addition to a lookup, when an output filter is defined, the answer from a lookup is passed to the filter prior to being sent back to the requestor.  This allows for parsing and modification of answers in a lookup in a pluggable way.

## Usage

To use an output filter, you can call the `output_filter` lookup method.  Eg: to parse all responses through the encryption output filter, providing "eyaml" style decryption of strings, you can specify....

{% highlight ruby %}
lookup :main do
  datasource :file {
    ...
  }

  output_filter :encryption
{% endhighlight %}

Any strings containing the identifiable pattern `ENC[...]` as per eyaml standards will be decrypted via eyaml.

## Available filters

Currently there are two output filters shipped with Jerakia, `encryption` and `strsub`

### encryption

#### Description

The `encryption` filter will search for strings in the outputted data matching eyamls encryption syntax and use the native eyaml libraries to decrypt them

#### Usage

{% highlight ruby %}
output_filter :encryption
{% endhighlight %}

### strsub

#### Description

The `strsub` filter will parse the data for strings matching `%{var}` and attempt to replace the tag with the corresponding value `var` from the scope provided with the lookup.

#### Usage

{% highlight ruby %}
output_filter :strsub
{% endhighlight %}


