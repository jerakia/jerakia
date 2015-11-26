---
layout: minimal
---

# Datasources

## The Dummy datasource

The dummy datasource is for testing purposes, it has one optional parameter of `return` which is the answer it will always return

### Example

{% highlight ruby %}

lookup :default do
  datasource :dummy, {
    :return => "hello world"
  }
end

{% endhighlight %}
