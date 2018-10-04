policy :dig do

  lookup :main do
    datasource :dummy, {
      :return => {
        'document' =>  {
          'settings' => {
            'foo' => 'bar'
          }
        }
      }
    }

    output_filter :dig, [ 'document', 'settings', request.key ]
  end

  lookup :second do
    datasource :dummy, {
      :return => {
        'document' =>  {
          'settings' => {
            'tango' => 'bar'
          }
        }
      }
    }

    output_filter :dig, [ 'document', 'settings', request.key ]
  end
end

