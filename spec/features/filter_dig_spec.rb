require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'Digging values' do
    context 'when looking up using the dig parameter' do
      let(:request) do
        Jerakia::Request.new(
          namespace: 'test',
          key: 'tango',
          policy: 'dig'
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should return the answer' do
        expect(answer.payload).to eq('bar')
      end

      it 'should have a found state' do
        expect(answer.found?).to eq(true)
      end

    end
    context 'when a dug key is not found' do
      let(:request) do
        Jerakia::Request.new(
          key: 'bad_key',
          policy: 'dig'
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should return nil' do
        expect(answer.payload).to eq(nil)
      end

      it 'should be set to not found' do
        expect(answer.found?).to eq(false)
      end

    end

  end
end
