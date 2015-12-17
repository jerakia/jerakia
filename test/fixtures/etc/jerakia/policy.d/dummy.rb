policy :dummy do

  lookup :lookup_options do
    datasource :dummy, {
      :return => {},
    }
    confine request.key, 'lookup_options'
    stop
  end

  lookup :default do
    datasource :dummy, {
      :return => "Dummy data string"
    }
  end
end

