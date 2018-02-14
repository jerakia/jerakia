require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'Without namespace' do
    context 'first result lookup' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'biscuits'
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have an array as a payload' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain the entries for dev' do
        expect(answer.payload).to eq(["gingernuts", "jammiedodgers", "custardcreams"])
      end
    end
    context 'array lookup' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'biscuits',
          lookup_type: :cascade,
          merge: :array
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have an array as a payload' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain all the elements' do
        expect(answer.payload).to eq(["gingernuts", "jammiedodgers", "custardcreams", "richtea", "digestive"])
      end
    end
  end
end


