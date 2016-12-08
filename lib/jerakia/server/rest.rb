require 'sinatra'
require 'jerakia'
require 'jerakia/server/auth'
require 'json'
require 'jerakia/scope/server'

class Jerakia
  class Server
    class Rest < Sinatra::Base

      def self.jerakia
        Jerakia::Server.jerakia
      end

      def jerakia
        self.class.jerakia
      end

      def auth_denied
        halt(401, { :status => 'failed', :message => 'unauthorized' }.to_json)
      end

      def authenticate!
        token = env['HTTP_X_AUTHENTICATION']
        auth_denied if token.nil?
        unless Jerakia::Server::Auth.authenticate(token)
          auth_denied
        end
      end

      before do
        content_type 'application/json'
      end

      get '/' do
        auth_denied
      end

      get '/v1/lookup/:key' do
        authenticate!
        request_opts = {
          :key => params['key'],
          :namespace => params['namespace'].split(/\//),
        }

        request_opts[:policy] = params['policy'].to_sym if params['policy']
        begin
          request = Jerakia::Request.new(request_opts)
          answer = jerakia.lookup(request)
        rescue Jerakia::Error => e
          halt(501, { :status => 'failed', :message => e.message }.to_json)
        end
        {
          :status => 'ok',
          :payload => answer.payload
        }.to_json
      end

      get '/v1/scope/:realm/:identifier' do
        resource = Jerakia::Scope::Server.find(params['realm'], params['identifier'])
        if resource.nil?
          halt(404, { :status => 'failed', :message => "No scope data found" }.to_json)
        else
          {
            :status => 'ok',
            :payload => resource.scope
          }.to_json
        end
      end

      put '/v1/scope/:realm/:identifer' do
        scope = JSON.parse(request.body.read)
        uuid = Jerakia::Scope::Server.put(params['realm'], params['identifier'], scope)
        {
          :status => 'ok',
          :uuid => uuid
        }.to_json
      end

      get '/v1/scope/:realm/:identifier/uuid' do
        resource = Jerakia::Scope::Server.find(params['realm'], params['identifier'])
        if resource.nil?
          halt(404, { :status => 'failed', :message => "No scope data found" }.to_json)
        else
          {
            :status => 'ok',
            :uuid => resource.uuid
          }.to_json
        end
      end
    end
  end
end
