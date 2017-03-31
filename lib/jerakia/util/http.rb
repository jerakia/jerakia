require 'net/http'
require 'json'
require 'openssl'

class Jerakia
  module Util
    class Http

      class << self

        def post(uri_str, data={}, headers={}, options={})
          uri = URI.parse(uri_str)
          request = Net::HTTP::Post.new(uri.path)
          request.body = data.to_json
          http_send(uri, request, headers, options) 
        end

        def put(uri_str, data={}, headers={}, options={})
          uri = URI.parse(uri_str)
          request = Net::HTTP::Put.new(uri.path)
          request.body = data.to_json
          http_send(uri, request, headers, options)
        end


        def http_send(uri, request, headers={}, options={})
          request.add_field('Content-Type', options[:content_type]) if options[:content_type]


          headers.each do |header, value|
            request.add_field(header, value)
          end
          http = Net::HTTP.new(uri.host, uri.port)
          if options[:ssl]
            http.use_ssl = true
            http.verify_mode = options[:ssl_verify] ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
            http.cert = OpenSSL::X509::Certificate.new(options[:ssl_cert]) if options[:ssl_cert]
            http.key = OpenSSL::PKey::RSA.new(options[:ssl_key]) if options[:ssl_key]
          end
          begin
            response = http.request(request)
            return response
          rescue => e
            raise Jerakia::HTTPError, e.message
          end
        end
      end
    end
  end
end




