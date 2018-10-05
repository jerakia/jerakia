class Jerakia::Datasource::Dummy < Jerakia::Datasource::Instance
  option :return, :default => 'Returned data'
  def lookup
    reply do |response|
      response.namespace(request.namespace).key(request.key).ammend(options[:return])
    end
  end
end


