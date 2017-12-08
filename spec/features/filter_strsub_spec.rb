require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'Substr values' do
    context 'when looking up using the strsub outputfilter' do
      let(:request) do
        Jerakia::Request.new(
          key: 'sub_value',
          namespace: [ 'test' ],
          metadata: { "env" => "prod" }
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should return the answer' do
        expect(answer.payload).to eq('Environment is prod')
      end

      it 'should have a found state' do
        expect(answer.found?).to eq(true)
      end

    end
  end
end
