require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config => "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'Fragments' do
    context 'without fragements' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev', hostname: 'example' },
          key: 'teststring',
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have a string as a payload' do
        expect(answer.payload).to be_a(String)
      end

      it 'should contain the string valid_string' do
        expect(answer.payload).to eq('valid_string')
      end
    end

    context 'when a yaml file and a .d exist' do
      let(:request) do
        Jerakia::Request.new(
          key: 'main',
          namespace: ['fragments']
        )
      end

      it 'should contain the data from the parent' do
        expect(answer.payload).to eq('mummy bear')
      end
    end

    context 'when a value spans over a .d' do
      let(:request) do
        Jerakia::Request.new(
          key: 'frag_array',
          namespace: ['fragments']
        )
      end

      it 'should return an array' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should have all the values from all the files' do
        expect(answer.payload).to eq(%w(first second third fourth fifth sixth))
      end
    end
  end
end
