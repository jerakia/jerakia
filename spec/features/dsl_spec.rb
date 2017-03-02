# Tests for the DSL parser
#

require 'spec_helper'


describe Jerakia::Launcher do

  let(:jerakia) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) {
    Jerakia::Request.new(
      :key => 'teststring',
      :namespace => [ 'test' ],
      :metadata => { 'env' => 'dev' }
    )
  }

  

  it "should parse a policy" do
    custom_policy = described_class.evaluate do
      policy :foo do
        lookup :bar do
          datasource :dummy, { :return => "hello world" }
        end
      end
    end
    answer = custom_policy.run(request) 
    expect(answer.payload).to eq('hello world')
  end

  context "confine" do
    it "should confine a lookup based on metadata scope" do
      custom_policy = described_class.evaluate do
        policy :default do
          lookup :first do
            datasource :dummy, { :return => "first lookup" }
            confine scope[:env], "prod"
          end

          lookup :second do
            datasource :dummy, { :return => "second lookup" }
          end
        end
      end
      answer = custom_policy.run(request) 
      expect(answer.payload).to eq('second lookup')

      custom_policy = described_class.evaluate do
        policy :default do
          lookup :first do
            datasource :dummy, { :return => "first lookup" }
            confine scope[:env], "dev"
          end

          lookup :second do
            datasource :dummy, { :return => "second lookup" }
          end
        end
      end
      answer = custom_policy.run(request) 
      expect(answer.payload).to eq('first lookup')
    end
  end
  context "exclude" do
    it "should exclude a lookup based on metadata scope" do
      custom_policy = described_class.evaluate do
        policy :default do
          lookup :first do
            datasource :dummy, { :return => "first lookup" }
            exclude scope[:env], "prod"
          end

          lookup :second do
            datasource :dummy, { :return => "second lookup" }
          end
        end
      end
      answer = custom_policy.run(request) 
      expect(answer.payload).to eq('first lookup')

      custom_policy = described_class.evaluate do
        policy :default do
          lookup :first do
            datasource :dummy, { :return => "first lookup" }
            exclude scope[:env], "dev"
          end

          lookup :second do
            datasource :dummy, { :return => "second lookup" }
          end
        end
      end
      answer = custom_policy.run(request) 
      expect(answer.payload).to eq('second lookup')
    end
  end

end
