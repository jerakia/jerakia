require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'resolving datatypes' do
    context 'expecting a true value' do
      let(:request) do
        Jerakia::Request.new(
          key: 'booltrue',
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have a boolean true class  as a payload' do
        expect(answer.payload).to be_a(TrueClass)
      end
    end
    context 'expecting a false value' do
      let(:request) do
        Jerakia::Request.new(
          key: 'boolfalse',
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have a boolean false class  as a payload' do
        expect(answer.payload).to be_a(FalseClass)
      end
    end
  end
end
