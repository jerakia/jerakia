require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'YAML scope handler' do
    context 'without scope loaded' do
      let(:request) do
        Jerakia::Request.new(
          key: 'beers',
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have an array as a payload' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain the correct data' do
        expect(answer.payload).to eq(['estrella','victoria'])
      end
    end

    context 'with YAML scope loaded' do
      let(:request) do
        Jerakia::Request.new(
          key: 'beers',
          namespace: ['test'],
          scope: 'yaml',
          scope_options: { 'file' => 'test/fixtures/etc/jerakia/scope.yaml' },
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have an array as a payload' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain the correct data' do
        expect(answer.payload).to eq(['cruzcampo','sanmiguel'])
      end
    end

  end
end
