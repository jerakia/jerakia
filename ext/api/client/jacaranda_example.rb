require 'rest_client'
require 'json'
url='http://localhost:4567/craig/port'

payload={
    :namespace => [ "apache" ],
    :lookup_type => :first,
    :metadata => {
      :environment => "development"
    }
}.to_json


response = RestClient.get url, :params => { :payload => payload }
puts response.to_json


