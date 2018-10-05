require 'spec_helper'

describe Jerakia::Request do
  context 'with no arguments' do
    let(:subject) { Jerakia::Request.new }
    it 'should contain our defaults' do
      expect(subject.key).to eq nil
      expect(subject.policy).to eq 'default'
    end
  end

  context 'with arguments' do
    let(:subject) { Jerakia::Request.new(key: 'foo') }

    it 'should merge the arguments with the defaults' do
      expect(subject.key).to eq 'foo'
      expect(subject.policy).to eq 'default'
    end
  end
end
