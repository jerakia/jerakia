require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'Hashes' do
    context 'first result lookup' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'hash',
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have a hash as a payload' do
        expect(answer.payload).to be_a(Hash)
      end

      it 'should contain the string valid_string' do
        expect(answer.payload).to eq({ 
          "key1"=>{"element2"=>"env"}, 
          "key2"=>{"element3"=>
            {"subelement3"=>"env"}
          }, 
          "key3"=>"env"
        })
      end
    end

    context 'cascade hash result lookup' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'hash',
          lookup_type: :cascade,
          merge: :hash,
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have a hash as a payload' do
        expect(answer.payload).to be_a(Hash)
      end

      it 'should contain the string valid_string' do
        expect(answer.payload).to eq( {
          "key0" => { "element0"=>"common" }, 
          "key1" => {"element2"=>"env"},
          "key2" => {"element3"=>{"subelement3"=>"env"}}, 
          "key3" => "env"}
      )
      end
    end

    context 'cascade deep_hash result lookup' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'hash',
          lookup_type: :cascade,
          merge: :deep_hash,
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have a hash as a payload' do
        expect(answer.payload).to be_a(Hash)
      end

      it 'should contain a correctly merged hash' do
        expect(answer.payload).to eq( {
          "key0"=>{"element0"=>"common"}, 
          "key1"=>{"element1"=>"common", "element2"=>"env"}, 
          "key2"=>{"element1"=>"common", "element2"=>{"subelement2"=>"common"}, "element3"=>{"subelement3"=>"env"}}, 
          "key3"=>"env"
        })
      end
    end

  end
end
