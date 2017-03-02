require 'jerakia/cache/file'

Jerakia::Datasource.define :file_new do

  option :searchpath, :required => true do |opt|
    opt.is_a?(Array)
  end

  option :format,  :default => :yaml
  option :docroot, :default => '/var/lib/jerakia/data'
  option :extention

  feature :keyless

  action do |lookup, response, options|
    response.submit('foo')
  end


end
