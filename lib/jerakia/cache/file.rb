require 'jerakia/cache'

class Jerakia::Cache::File < Jerakia::Cache
  
  
  def initialize
    super
  end


  def state(filename)
    if ::File.exists?(filename)
      ::File.stat(filename).mtime
    else
      nil
    end
  end

  def add(index,data)
    @@bucket[index] ||= {}
    @@bucket[index][:state] = state(index)
    super
  end

  def valid?(index)
    if in_bucket?(index)
      @@bucket[index][:state] == state(index)
    else
      false
    end
  end

end
