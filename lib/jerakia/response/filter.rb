class Jerakia::Response
  module Filter
    def filter!(name, opts = {})

      unless opts.is_a?(Hash) || opts.is_a?(Array)
        raise Jerakia::PolicyError, "Output filters may only accept hashes or arrays as arguments"
      end
      Jerakia::Util.autoload('response/filter', name)
      Jerakia.log.debug("Invoking output filter #{name}")
      instance_eval "extend Jerakia::Response::Filter::#{name.to_s.capitalize}"
      instance_eval "self.filter_#{name}(#{opts})"
    end
  end
end
