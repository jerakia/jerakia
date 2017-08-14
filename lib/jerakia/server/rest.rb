require 'sinatra'
require 'jerakia'
require 'jerakia/server/auth'
require 'jerakia/scope/server'
require 'json'
require 'msgpack'

class Jerakia
  class Server
    class Rest < Sinatra::Base

      def self.jerakia
        Jerakia::Server.jerakia
      end

      def initialize
        @authorized_tokens={}
        super
      end

      def jerakia
        self.class.jerakia
      end

      def auth_denied
        request_failed('unauthorized', 401)
      end

      def token_ttl
        Jerakia::Server.config["token_ttl"]
      end

      def token_valid?(token)
        return false unless @authorized_tokens[token].is_a?(Time)
        (Time.now - @authorized_tokens[token]) < token_ttl.to_i
      end

      def authenticate!
        token = env['HTTP_X_AUTHENTICATION']
        auth_denied if token.nil?
        return true if token_valid?(token)
        unless Jerakia::Server::Auth.authenticate(token)
          auth_denied
        end
        @authorized_tokens[token] = Time.now
      end

      def encode_result(data)
        case @content_type
        when :json
          return data.to_json
        when :msgpack
          return data.to_msgpack
        end
      end

      def determine_content_type!
        if not env.key?('CONTENT_TYPE') or env['CONTENT_TYPE'] == "application/json"
          content_type 'application/json'
          @content_type = :json
        elsif env['CONTENT_TYPE'] == "application/x-msgpack"
          content_type 'application/x-msgpack'
          @content_type = :msgpack
        else
          wrong_media_type("Content type #{env['CONTENT_TYPE']} not supported", 415)
        end
      end

      before do
        authenticate!
        determine_content_type!
      end

      get '/' do
        auth_denied
      end

      def wrong_media_type(message, status_code=415)
        halt(status_code, {'Content-Type' => 'text/plain'}, message)
      end

      def request_failed(message, status_code=501)
        halt(status_code, 
             encode_result({ :status => 'failed', 
                             :message => message }))
      end

      def mandatory_params(mandatory, params)
        mandatory.each do |m|
          unless params.include?(m)
            request_failed("Must include parameter #{m} in request", 400)
          end
        end
      end

      get '/v1/lookup' do
        request_failed("Keyless lookups not supported in this version of Jerakia")
      end

      get '/v1/lookup/:key' do
        mandatory_params(['namespace'], params)
        request_opts = {
          :key => params['key'],
          :namespace => params['namespace'].split(/\//),
        }

        metadata = params.select { |k,v| k =~ /^metadata_.*/ }
        scope_opts = params.select { |k,v| k =~ /^scope_.*/ }

        request_opts[:metadata] = Hash[metadata.map { |k,v| [k.gsub(/^metadata_/, ""), v] }]
        request_opts[:scope_options] = Hash[scope_opts.map { |k,v| [k.gsub(/^scope_/, ""), v] }]


        request_opts[:policy] = params['policy'].to_sym if params['policy']
        request_opts[:lookup_type] = params['lookup_type'].to_sym if params['lookup_type']
        request_opts[:merge] = params['merge'].to_sym if params['merge']
        request_opts[:scope] = params['scope'].to_sym if params['scope']
        request_opts[:use_schema] = false if params['use_schema'] == 'false'

        begin
          request = Jerakia::Request.new(request_opts)
          answer = jerakia.lookup(request)
        rescue Jerakia::Error => e
          request_failed(e.message, 501)
        end
        encode_result({ :status => 'ok', 
                        :payload => answer.payload})
      end

      get '/v1/scope/:realm/:identifier' do
        resource = Jerakia::Scope::Server.find(params['realm'], params['identifier'])
        if resource.nil?
          halt(404, 
               encode_result({:status => 'failed', 
                              :message => "No scope data found"}))
        else
          encode_result({:status => 'ok',
                         :payload => resource.scope})
        end
      end

      put '/v1/scope/:realm/:identifier' do
        scope = JSON.parse(request.body.read)
        uuid = Jerakia::Scope::Server.store(params['realm'], params['identifier'], scope)
        encode_result({:status => 'ok',
                       :uuid => uuid})
      end

      get '/v1/scope/:realm/:identifier/uuid' do
        resource = Jerakia::Scope::Server.find(params['realm'], params['identifier'])
        if resource.nil?
          request_failed('No scope data found', 404)
        else
          encode_result({:status => 'ok',
                         :uuid => resource.uuid})
        end
      end
    end
  end
end
