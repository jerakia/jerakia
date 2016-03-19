---
layout: minimal
---

# The `jerakia` command

## Usage

`jerakia <subcommand> [OPTIONS]`

## Subcommands
### help

Display help information

### version

Display jerakia version information 


### lookup

The lookup subcommands take a third argument as the key followed by options

{% highlight console %}
jerakia lookup <key> [options]
{% endhighlight %}

#### options

#####  `c, [--config=CONFIG]`
Specify a different configuration file from the default (`/etc/jerakia/jerakia.yaml`)

#####  `p, [--policy=POLICY]` 
Specify a policy to use for the lookup, default: default

#####  `n, [--namespace=NAMESPACE]`  
Namespace of the request key being looked up

#####  `t, [--type=TYPE]`           
The type of lookup, the default type of `first` will cause Jerakia to return the first value it finds.  Setting this option to `cascade` will cause Jerakia to continue through the hierarchy and return merged results.  (see --merge-type)

#####  `s, [--scope=SCOPE]`       
Specify an alternative scope handler (default: metadata)

#####  `m, [--merge-type=MERGE_TYPE]`
When using `--type=cascade` this option specifies how the results should be merged, valid values are `array` and `hash`

#####  `l, [--log-level=LOG_LEVEL]`
Specify a different log level (default configured in jerakia.yaml)

#####  `D, [--debug], [--no-debug]`
Enable debugging mode to the console.  Setting this option overrides `--log-level`

#####  `S, [--schema], [--no-schema]`
Enable or disable [schema lookup](/schema/).  Enabled by default

#####  `d, [--metadata=key:value]` 
Metadata to send with the request as a space spearated list of command delimited key value pairs


## Examples

### Looking up data
{% highlight console %}
$ jerakia lookup port --namespace apache
{% endhighlight %}

### Providing metadata scope
{% highlight console %}
$ jerakia lookup port --namespace apache \
  --metadata fqdn:localhost.example.com \
  environment:dev
{% endhighlight %}
