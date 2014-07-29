policy :default do
  lookup :yaml do
    data_source :yaml
    deep_merge
    continue
  end

  lookup :mysql do
    data_source :hiera_mysql
    handler :default
  end


  route :default, [ :yaml ]
  route { :calling_module => "apache" }, [ :mysql, :yaml ]

end

