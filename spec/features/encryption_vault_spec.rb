require 'spec_helper'
require 'jerakia/encryption'
require 'net/http'
require 'base64'

describe Jerakia::Encryption do
  let(:jerakia) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:provider) { described_class.handler }
  let(:token) { '0759f625-db79-da0f-d9bd-104c122b5f78' }
  let(:expired_token) { 'fb3700a1-d740-5223-f2b2-90ab471acf67' }
  let(:vault_encrypted) { 'vault:v1:bSZeMAas/9yYapGFg3pMPdDOoBlg479xQdpzm36RpA==' }
  let(:vault_decrypted) { 'foobar' }
  let(:vault_decrypted_base64) { Base64.encode64(vault_decrypted).chomp }
  let(:token_headers) {{ "X-Vault-Token" => token }}
  let(:http_response) { Class.new }
      
  let(:encrypt_url) { "#{Jerakia.config[:encryption]['vault_addr']}/v1/transit/encrypt/jerakia" }
  let(:decrypt_url) { "#{Jerakia.config[:encryption]['vault_addr']}/v1/transit/decrypt/jerakia" }

  let(:login_uri) { 'http://127.0.0.1:8200/v1/auth/approle/login' }
  let(:secret) { Jerakia.config[:encryption]["vault_secret_id"] }
  let(:role) { Jerakia.config[:encryption]["vault_role_id"] }
  let(:vault_token_response) { %Q(
      {
        "auth": {
          "renewable": true,
          "lease_duration": 2764800,
          "metadata": {},
          "policies": [
            "default",
            "dev-policy",
            "test-policy"
          ],
          "accessor": "5d7fb475-07cb-4060-c2de-1ca3fcbf0c56",
          "client_token": "#{token}"
        },
        "warnings": null,
        "wrap_info": null,
        "data": null,
        "lease_duration": 0,
        "renewable": false,
        "lease_id": "",
        "request_id": "988fb8db-ce3b-0167-0ac7-1a568b902d75"
      }
    )
  }

  describe "Provider" do
    context "when loaded" do
      it "should have an encrypt feature" do
        expect(provider.features?(:encrypt)).to eq(true)
      end

      it "should have a decrypt feature" do
        expect(provider.features?(:decrypt)).to eq(true)
      end
    end

    context "signiture" do
      it "should have a signiture that matches a valid vault string" do
        vault_encrypted = 'vault:v1:bSZeMAas/9yYapGFg3pMPdDOoBlg479xQdpzm36RpA=='
        not_vault_encrypted = 'bSZeMAas/9yYapGFg3pMPdDOoBlg479xQdpzm36RpA==:vault:v1'

        expect(vault_encrypted).to match(provider.signiture)
        expect(not_vault_encrypted).not_to match(provider.signiture)
      end
    end

    context "encrypting and decrypting" do
      it "should decrypt values" do

        provider.expects(:token).returns(token)
        Jerakia::Util::Http.expects(:post).with(decrypt_url, {'ciphertext' => vault_encrypted}, token_headers, {}).returns(http_response)

        http_response.expects(:body).returns("{ \"data\": { \"plaintext\": \"#{vault_decrypted_base64}\" } }")
        http_response.expects(:code_type).returns(Net::HTTPOK)
        expect(provider.decrypt(vault_encrypted)).to eq(vault_decrypted)
      end

      it "should encrypt values" do
        provider.expects(:token).returns(token)
        Jerakia::Util::Http.expects(:post).with(encrypt_url, { 'plaintext' => vault_decrypted_base64 + "\n"}, token_headers, {}).returns(http_response)

        http_response.expects(:body).returns("{ \"data\": { \"ciphertext\": \"#{vault_encrypted}\" } }")
        http_response.expects(:code_type).returns(Net::HTTPOK)
        expect(provider.encrypt(vault_decrypted)).to eq(vault_encrypted)
      end
    end

    context "Tokens" do
      context "When no token is available" do

        it "should request a new token" do
          Jerakia::Util::Http.expects(:post).returns(http_response)
          http_response.expects(:code_type).returns(Net::HTTPOK)
          http_response.expects(:body).returns(vault_token_response)
          expect(provider.token).to eq(token)
        end
      end

      context "When a token is expired" do
        it "should attempt to fetch a new token" do


          login_response = Class.new
          retry_response = Class.new

          #allow(provider).to receive(:token).and_return(expired_token, token)
          provider.expects(:token).twice.returns(expired_token, token)

          Jerakia::Util::Http.expects(:post).with(encrypt_url, { 'plaintext' => vault_decrypted_base64 + "\n"}, { "X-Vault-Token" => expired_token }, {}).returns(http_response)
          http_response.expects(:code_type).returns(Net::HTTPForbidden)
          http_response.expects(:code).returns("403")
          http_response.expects(:body).returns('{"errors":["missing client token"]}')
          Jerakia::Util::Http.expects(:post).with(login_uri, { "role_id" => role, "secret_id" => secret }, {}, {}).returns(login_response)
          login_response.expects(:code_type).returns(Net::HTTPOK)
          login_response.expects(:body).returns(vault_token_response)
          Jerakia::Util::Http.expects(:post).with(encrypt_url, { 'plaintext' => vault_decrypted_base64 + "\n"}, { "X-Vault-Token" => token }, {}).returns(retry_response)
          retry_response.expects(:code_type).returns(Net::HTTPOK)
          retry_response.expects(:body).returns("{ \"data\": { \"plaintext\": \"#{vault_decrypted_base64}\" } }")
          provider.encrypt(vault_decrypted)
        end
      end
    end
  end
end
