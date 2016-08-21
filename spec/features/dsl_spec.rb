# Tests for the DSL parser
#

require 'spec_helper'


describe Jerakia::Launcher do

  let(:jerakia) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) {
    described_class.new(Jerakia::Request.new(
      :key => 'teststring',
      :namespace => [ 'test' ],
      :metadata => { 'env' => 'dev' }
    ))
  }

  

  it "should parse a policy" do
    answer = request.evaluate do
      policy :foo do
        lookup :bar do
          datasource :dummy, { :return => "hello world" }
        end
      end
    end
    expect(answer.payload).to eq('hello world')
  end

  context "confine" do
    it "should confine a lookup based on metadata scope" do
      answer = request.evaluate do
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
      expect(answer.payload).to eq('second lookup')

      answer = request.evaluate do
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
      expect(answer.payload).to eq('first lookup')
    end
  end
  context "exclude" do
    it "should exclude a lookup based on metadata scope" do
      answer = request.evaluate do
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
      expect(answer.payload).to eq('first lookup')

      answer = request.evaluate do
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
      expect(answer.payload).to eq('second lookup')
    end
  end

end
