class Jacaranda::Response
  module Filter
      def filter!(name,opts)
        Jacaranda::Util.autoload('response/filter', name)
        instance_eval "extend Jacaranda::Response::Filter::#{name.to_s.capitalize}"
        instance_eval "self.filter_#{name.to_s} (#{opts})"
      end
  end
end
