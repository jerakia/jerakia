require 'spec_helper'


class Hiera
  module Backend
    class Config
      def self.[](key)
        { :jerakia => {
            :config => './test/fixtures/etc/jerakia/jerakia.yaml' 
        } }[key]
      end
    end
  
    describe Jerakia_backend do
      before :each do
        @backend = Hiera::Backend::Jerakia_backend.new
      end
    
      it "should initialize" do
        expect(@backend).to be_a(Hiera::Backend::Jerakia_backend)
      end

      describe "#lookup" do
        context "when returning a string" do
          before do
            @response=@backend.lookup(
              "test::teststring", 
              {:env => "dev", :hostname => "example"}, 
              {}, 
              nil
            )
          end

          it "should return a string" do
            expect(@response).to be_a(String)
          end

          it "should have the right value" do
            expect(@response).to eq("valid_string")
          end
        end

        context "when using a different policy" do
          before do
            @response=@backend.lookup(
              "test::teststring", 
              {:jerakia_policy => "dummy", :env => "dev", :hostname => "example"}, 
              {}, 
              nil
            )
          end
          it "should use the policy in the metadata" do
            expect(@response).to eq("Dummy data string")
          end
        end

      end
    
    end


  end
end



