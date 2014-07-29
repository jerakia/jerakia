 class Jacaranda::Plugin::Scope << Jacaranda::Plugin
	    class << self
	    attr_reader :handler

	    

	    def load
	      scopename="facts"
	      require "jacaranda/plugin/scope/#{scopename}"
	      @handler = Jacaranda::Plugin::Scope::Facts.new
	    end

	    def test
		    puts "TEST METHOD"
	    end
	    end

	    attr_accessor :data
    end

