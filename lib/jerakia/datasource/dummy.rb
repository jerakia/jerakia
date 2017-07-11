class Jerakia::Datasource::Dummy < Jerakia::Datasource::Instance
  option :return, :default => 'Returned data'
  def lookup
    answer options[:return]
  end
end


