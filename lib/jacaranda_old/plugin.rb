class Jacaranda::Plugin
	require 'jacaranda/plugin/scope'
	class << self
		def load_all
			Jacaranda::Plugin::Scope.load
		end
	end
end

