policy :http_lookup do


  lookup :main do
    datasource :http, {
      :host => 'cms.test.com',
      :port => 80,
      :output => 'json',
      :paths => [
        '/test/one',
        '/test/two'
      ]
    }
  end
end

