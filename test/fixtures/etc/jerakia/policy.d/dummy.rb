policy :dummy do

  lookup :default do
    datasource :dummy, {
      :return => "Dummy data string"
    }
  end
end

