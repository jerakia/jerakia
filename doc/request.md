### Jacaranda Requests ###

A lookup is made to Jacaranda by defining a lookup request.  A lookup request contains the following information

* `key` : The lookup key to search for
* `namespace` : Namespace containing the key
* `policy` : Jacaranda policy to use for the search request
* `lookup_type` : Can be set to either `:first` or `:cascade` - when set to `:first` Jacaranda will stop at the first result it finds, and `:cascade` will continue searching and combine the results
* `merge` : When `:cascade` is set for the `lookup_type` this determines how to handle the results.  Can be `:array` or `:hash`
* `metadata` : Other data, by default the scope is loaded from this hash

For example, at a ruby level, we define a Jacaranda request like this

    req = Jacaranda::Request.new(
      :key => 'port',
      :namespace => [ 'apache' ],
      :policy => "puppet",
      :lookup_type => :first,
      :metadata => { :environment => 'development' }
    )
    
    
