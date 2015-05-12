namespace [ 'apache' ] do 

  defaults {
    :expect => :any
    :cascade => false,
  }

  element 'port',   { :expect => :integer,  :cascade => false }
  element 'users',  { :expect => :array,    :cascade => true }
  element 'vhosts', { :expect => :hash,     :cascade => true, :merge => :hash }

  element [ 'docroot', 'ipaddress', 'servername', 'serveradmin' ], {
    :expect  => :string,
    :cascade => :false,
  }

end



