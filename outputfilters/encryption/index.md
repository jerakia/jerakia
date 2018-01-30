---
layout: default
---

# Output Filters

## encryption

### Description

The `encryption` output filter can be used if you have a [valid encryption provider](/encryption) loaded, such as Vault.  Encryption providers expose a signiture as a regular expression. With the `encryption` output filter enabled, any results that come back from any datasource matching the regex of the providers signiture (eg: vault:v1:ZDXtHprxLDnAJySOcyAnc5F2RJlIGtOnoxeJICQXUrYf9A3iOC76) then the string is passed to the decrypt method of the encryption provider to be decrypted before it's passed back to the requestor.

### Usage

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
