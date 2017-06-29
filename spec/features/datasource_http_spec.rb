require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  before(:each) do
    response = '{ "foo": "bar" }'
    stub_request(:get, "http://cms.test.com/test/one").
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response, headers: {})

  end

  describe 'HTTP datasource' do
    context 'performing HTTP sourced lookups' do
      let(:request) do
        Jerakia::Request.new(
          key: 'foo',
          policy: 'http_lookup',
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should return the correct parsed answer' do
        expect(answer.payload).to eq('bar')
      end

    end
  end
end

