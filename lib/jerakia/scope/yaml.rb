#
class Jerakia::Scope
  module Yaml
    def create
      yaml_file = request.scope_options["file"] || "./jerakia_scope.yaml"
      Jerakia.crit("No such file for scope, #{yaml_file}") unless File.exists?(yaml_file)
      data = YAML.load(File.read(yaml_file))
      data.each do |key,val|
        value[key.to_sym] = val
      end
    end
  end
end

