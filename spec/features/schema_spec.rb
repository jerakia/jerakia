require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'Schemas' do
    context 'when a schema defines a hash lookup' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'cities',
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have a hash as a payload' do
        expect(answer.payload).to be_a(Hash)
      end

      it 'should contain hash elements from the whole tree' do
        expect(answer.payload).to eq(
          {"france"=>"paris", "argentina"=>"buenos aires", "spain"=>"madrid", "uk" => "london"}
        )
      end
    end

    context 'when schema lookups are disabled' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'cities',
          namespace: ['test'],
          use_schema: false
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have a hash as a payload' do
        expect(answer.payload).to be_a(Hash)
      end

      it 'should only contain the first result' do
        expect(answer.payload).to eq( 
          {"uk"=>"london", "spain"=>"madrid"}
        )
      end
    end

    context 'when a schema defines an array' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'jewels',
          namespace: ['test'],
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have an array as a payload' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain all elements of the tree' do
        expect(answer.payload).to eq( 
          ["ruby","opal","diamond","quartz","topaz"]
        )
      end
    end

    context 'when a schema defines an alias' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'stones',
          namespace: ['foo'],
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have an array as a payload' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain the data from test::jewels' do
        expect(answer.payload).to eq( 
          ["ruby", "opal", "diamond", "quartz", "topaz"]
        )
      end
    end

    context 'when a schema defines an alias and overrides lookup parameters' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'all_stones',
          namespace: ['foo'],
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have an array as a payload' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain the data from test::jewels' do
        expect(answer.payload).to eq( 
          ["ruby","opal","diamond","quartz","topaz"]
        )
      end
    end

    context 'when a schema defines an alias and overrides just the namespace' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev' },
          key: 'jewels',
          namespace: ['foo'],
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should have an array as a payload' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain the data from the test namespace and pick up the new schema directives' do
        expect(answer.payload).to eq( 
          ["ruby", "opal", "diamond", "quartz", "topaz"]
        )
      end
    end



  end
end
