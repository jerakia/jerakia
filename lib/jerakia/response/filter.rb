class Jerakia::Response
  module Filter
    def filter!(name, opts = {})
      Jerakia::Util.autoload('response/filter', name)
      Jerakia.log.debug("Invoking output filter #{name}")
      instance_eval "extend Jerakia::Response::Filter::#{name.to_s.capitalize}"
      instance_eval "self.filter_#{name} (#{opts})"
    end
  end
end
