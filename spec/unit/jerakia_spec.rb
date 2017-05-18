require 'spec_helper'



describe Jerakia do

  before(:each) { Jerakia.instance_variable_set :@config, nil }

  let(:subject) { Jerakia.new(config: "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  it 'should initialize' do
    expect(subject).to be_a(Jerakia)
  end

  it 'should have a valid request object' do
    expect(request).to be_a(Jerakia::Request)
  end

  describe 'Configuring Jerakia' do
    context 'with a nonexistent config file' do
      let(:subject) { Jerakia.new(config: '/path/to/nothing.yaml', logfile: '/dev/null') }

      it 'should have our default config' do
        expect(subject.config['policydir']).to eq '/etc/jerakia/policy.d'
        expect(subject.config['logfile']).to eq '/var/log/jerakia/jerakia.log'
        expect(subject.config['databasedir']).to eq '/var/db/jerakia'
        expect(subject.config['loglevel']).to eq 'info'
      end
    end

    context 'with a config file' do
      let(:subject) { Jerakia.new(config: "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
      it 'should have overridden our defaults' do
        expect(subject.config['policydir']).not_to eq '/etc/jerakia/policy.d'
        expect(subject.config['logfile']).not_to eq '/var/log/jerakia/jerakia.log'
        expect(subject.config['loglevel']).not_to eq 'info'
      end
    end
  end

  describe 'Looking up' do
    context 'a string' do
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

      it 'it should contain the string valid_string' do
        expect(answer.payload).to eq('valid_string')
      end
    end

    context 'array' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev', hostname: 'example' },
          key: 'users',
          namespace: ['test']
        )
      end

      it 'should return an array' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain the users from example' do
        expect(answer.payload).to eq(%w(bob lucy david))
      end
    end

    context 'array cascade' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev', hostname: 'example' },
          key: 'users',
          namespace: ['test'],
          lookup_type: :cascade,
          merge: :array
        )
      end

      it 'should return an array' do
        expect(answer.payload).to be_a(Array)
      end

      it 'should contain all the users' do
        expect(answer.payload).to eq(%w(bob lucy david joshua craig karina max))
      end
    end

    context 'hash' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev', hostname: 'example' },
          key: 'accounts',
          namespace: ['test']
        )
      end

      it 'should return a hash' do
        expect(answer.payload).to be_a(Hash)
      end

      it 'should contain the first hash keys' do
        expect(answer.payload).to have_key('puppet')
        expect(answer.payload).to have_key('apache')
        expect(answer.payload).to_not have_key('oracle')
        expect(answer.payload).to_not have_key('admin')
      end
    end

    context 'merged hash' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev', hostname: 'example' },
          key: 'accounts',
          namespace: ['test'],
          lookup_type: :cascade,
          merge: :hash
        )
      end

      it 'should return a hash' do
        expect(answer.payload).to be_a(Hash)
      end

      it 'should contain the first hash keys' do
        expect(answer.payload).to have_key('puppet')
        expect(answer.payload).to have_key('apache')
        expect(answer.payload).to have_key('oracle')
        expect(answer.payload).to have_key('admin')
      end
    end

    context 'with host overrides' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev', hostname: 'localhost' },
          key: 'teststring',
          namespace: ['test']
        )
      end

      it 'should have a host specific value' do
        expect(answer.payload).to eq('localhost_specific')
      end
    end

    context 'with a different policy' do
      let(:request) do
        Jerakia::Request.new(
          metadata: { env: 'dev', hostname: 'localhost' },
          key: 'teststring',
          namespace: ['test'],
          policy: 'dummy'
        )
      end

      it 'should call the right policy' do
        expect(answer.payload).to eq('Dummy data string')
      end
    end

    #  let (:jerakia) { Jerakia.new(:config => "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }

    #   it "initalizes" do
    #    expect(jerakia).to be_a(Jerakia)
    #  end
  end
end
