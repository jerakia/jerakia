require 'sinatra'
require 'json'
require 'jacaranda'

jac=Jacaranda.new

get '/:policy/:key' do
  
  payload=JSON.load(params[:payload])

  policy=params[:policy]
  key=params[:key]
  p payload

  namespace=payload["namespace"]
  lookup_type=payload["lookup_type"]
  metadata=payload["metadata"]
  merge=payload["merge"]

  reqdata = {
    :policy => policy.to_sym,
    :key    => key
  }

  if namespace.is_a?(Array)
    reqdata[:namespace] = namespace
  end

  if metadata.is_a?(Hash)
    reqdata[:metadata] = metadata.inject({}) { |m,(k,v)| m[k.to_sym] = v; m }
  end

  if merge.is_a?(String)
    reqdata[:merge] = merge.to_sym
  end

  if lookup_type.is_a?(String)
    reqdata[:lookup_type] = lookup_type.to_sym
  end

  jacreq=Jacaranda::Request.new(reqdata)
  answer = jac.lookup(jacreq)
  answer.payload.to_json

end


