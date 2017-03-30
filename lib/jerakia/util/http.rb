require 'net/http'
require 'json'

class Jerakia
  module Util
    class Http

      class << self

        def post(uri_str, data={}, headers={}, content_type='application/json')
          uri = URI.parse(uri_str)
          request = Net::HTTP::Post.new(uri.path)
          request.body = data.to_json
          http_send(uri, request, headers, content_type)
        end

        def put(uri_str, data={}, headers={}, content_type='application/json')
          uri = URI.parse(uri_str)
          request = Net::HTTP::Put.new(uri.path)
          request.body = data.to_json
          http_send(uri, request, headers, content_type)
        end


        def http_send(uri, request, headers={}, content_type=nil)
          request.add_field('Content-Type', content_type) if content_type
          headers.each do |header, value|
            request.add_field(header, value)
          end
          begin
            response = Net::HTTP.new(uri.host, uri.port).start do |http|
              http.request(request)
            end
            return response
          rescue => e
            raise Jerakia::HTTPError, e.message
          end
        end
      end
    end
  end
end




