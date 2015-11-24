require 'spec_helper'

describe Hiera::Backend::Jerakia_backend do
  let(:subject) { Hiera::Backend::Jerakia_backend.new(config: './test/fixtures/etc/jerakia/jerakia.yaml') }

  it 'should initialize' do
    expect(subject).to be_a(Hiera::Backend::Jerakia_backend)
  end

  describe '#lookup' do
    context 'when returning a string' do
      let(:lookup) do
        subject.lookup(
          'test::teststring',
          { env: 'dev', hostname: 'example' },
          {},
          nil
        )
      end
      it 'should return a string' do
        expect(lookup).to be_a(String)
      end

      it 'should have the right value' do
        expect(lookup).to eq('valid_string')
      end
    end

    context 'when using a different policy' do
      let(:lookup) do
        subject.lookup(
          'test::teststring',
          { jerakia_policy: 'dummy', env: 'dev', hostname: 'example' },
          {},
          nil
        )
      end
      it 'should use the policy in the metadata' do
        expect(lookup).to eq('Dummy data string')
      end
    end
  end
end
