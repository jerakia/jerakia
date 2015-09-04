#
# Very primitive form of cache - but we'll make this smarter
#
#
class Jerakia::Cache

  @@bucket = {}

  def initialize
  end

  def add(index,data)
    @@bucket[index] ||= {}
    @@bucket[index][:content] = data
    data
  end

  def in_bucket?(index)
    @@bucket.has_key?(index)
  end

  ## default behaviour is always validate if exists.
  def valid?(index)
    in_bucket?(index)
  end
  
  def get(index)
    @@bucket[index][:content]
  end

  def bucket
    @@bucket
  end
end

