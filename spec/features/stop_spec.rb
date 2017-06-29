require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'Confined lookup' do
    context 'when looking up a confined lookup' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { testing: 'yes' },
          key: 'foo',
          namespace: ['test_conf'],
          lookup_type: :cascade,
          merge: :array,
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should return the answer' do
        expect(answer.payload).to eq(['Success'])
      end

    end

  end
end
